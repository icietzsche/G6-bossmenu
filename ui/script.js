let currencySymbol = '$';

function sendNUICallback(endpoint, data = {}) {
    fetch(`https://${GetParentResourceName()}/${endpoint}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    }).catch(() => {});
}

window.addEventListener('message', function(event) {
    const data = event.data;
    if (!data) return;

    const container = document.getElementById('menu-container');
    const jobLabel = document.getElementById('job-label');

    if (data.action === 'open') {
        if (data.currency) currencySymbol = data.currency;
        if (jobLabel) jobLabel.textContent = data.jobLabel || 'MESLEK ADI';
        if (container) container.style.display = 'block';
    } else if (data.action === 'close') {
        if (container) container.style.display = 'none';
    } else if (data.action === 'updateData') {
        const gradeList = document.getElementById('grade-list');
        if (gradeList) {
            gradeList.innerHTML = '<option value="" disabled selected>Rütbe Seç</option>';
            let grades = data.grades;
            if (grades) {
                if (!Array.isArray(grades)) grades = Object.values(grades);
                grades.forEach(grade => {
                    if (grade && grade.level !== undefined) {
                        const opt = document.createElement('option');
                        opt.value = grade.level;
                        opt.textContent = grade.name || grade.label;
                        gradeList.appendChild(opt);
                    }
                });
            }
        }

        const empList = document.getElementById('employee-list');
        const empTable = document.getElementById('employee-table');

        if (empList) {
            empList.innerHTML = '<option value="" disabled selected>Çalışan seç</option>';
        }
        if (empTable) {
            empTable.innerHTML = '';
        }

        let employees = data.employees;
        if (employees) {
            if (!Array.isArray(employees)) employees = Object.values(employees);
            employees.forEach(emp => {
                if (emp && emp.citizenid) {
                    if (empList) {
                        const opt = document.createElement('option');
                        opt.value = emp.citizenid;
                        opt.textContent = emp.name;
                        empList.appendChild(opt);
                    }
                    if (empTable) {
                        const row = document.createElement('tr');
                        const tdName = document.createElement('td');
                        tdName.textContent = emp.name;
                        const tdGrade = document.createElement('td');
                        tdGrade.textContent = emp.gradeLabel;
                        row.appendChild(tdName);
                        row.appendChild(tdGrade);
                        empTable.appendChild(row);
                    }
                }
            });
        }

        const balanceEl = document.getElementById('balance');
        if (balanceEl && data.balance !== undefined) {
            balanceEl.textContent = currencySymbol + Number(data.balance).toLocaleString();
        }

        const nearbyList = document.getElementById('nearby-players');
        if (nearbyList) {
            nearbyList.innerHTML = '<option value="" disabled selected>Oyuncu seç</option>';
            let nearby = data.nearbyPlayers;
            if (nearby) {
                if (!Array.isArray(nearby)) nearby = Object.values(nearby);
                nearby.forEach(p => {
                    if (p && p.playerId !== undefined) {
                        const opt = document.createElement('option');
                        opt.value = p.playerId;
                        opt.textContent = `${p.name} (${p.playerId})`;
                        nearbyList.appendChild(opt);
                    }
                });
            }
        }
    }
});

document.addEventListener('keyup', function(e) {
    if (e.key === 'Escape') {
        sendNUICallback('close');
    }
});

document.addEventListener('DOMContentLoaded', function() {
    const closeBtn = document.getElementById('close-btn');
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            sendNUICallback('close');
        });
    }

    const hireBtn = document.getElementById('hire-btn');
    if (hireBtn) {
        hireBtn.addEventListener('click', function() {
            const nearbyList = document.getElementById('nearby-players');
            const playerId = nearbyList ? nearbyList.value : null;
            if (playerId) {
                sendNUICallback('hirePlayer', { playerId: playerId, grade: 0 });
            }
        });
    }

    const fireBtn = document.getElementById('fire-btn');
    if (fireBtn) {
        fireBtn.addEventListener('click', function() {
            const empList = document.getElementById('employee-list');
            const citizenId = empList ? empList.value : null;
            if (citizenId) {
                sendNUICallback('fireEmployee', { citizenId: citizenId });
            }
        });
    }

    const setGradeBtn = document.getElementById('set-grade-btn');
    if (setGradeBtn) {
        setGradeBtn.addEventListener('click', function() {
            const empList = document.getElementById('employee-list');
            const gradeList = document.getElementById('grade-list');
            const citizenId = empList ? empList.value : null;
            const grade = gradeList ? gradeList.value : null;
            if (citizenId && grade !== null && grade !== '') {
                sendNUICallback('setGrade', { citizenId: citizenId, grade: grade });
            }
        });
    }

    const depositBtn = document.getElementById('deposit-btn');
    if (depositBtn) {
        depositBtn.addEventListener('click', function() {
            const moneyInput = document.getElementById('money-amount');
            const amt = parseInt(moneyInput ? moneyInput.value : '0', 10);
            if (amt > 0) {
                sendNUICallback('depositMoney', { amount: amt });
                if (moneyInput) moneyInput.value = '';
            }
        });
    }

    const withdrawBtn = document.getElementById('withdraw-btn');
    if (withdrawBtn) {
        withdrawBtn.addEventListener('click', function() {
            const moneyInput = document.getElementById('money-amount');
            const amt = parseInt(moneyInput ? moneyInput.value : '0', 10);
            if (amt > 0) {
                sendNUICallback('withdrawMoney', { amount: amt });
                if (moneyInput) moneyInput.value = '';
            }
        });
    }

    const refreshBtn = document.getElementById('refresh-data');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', function() {
            const empList = document.getElementById('employee-list');
            if (empList) {
                sendNUICallback('close');
            }
        });
    }

    const moneyAmountInput = document.getElementById('money-amount');
    if (moneyAmountInput) {
        moneyAmountInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
});
