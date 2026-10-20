
let gameData;

fetch('data.php')
    .then(response => response.json())
    .then(data => {
        gameData = data;
    });

const champions = document.querySelectorAll('.champ');
const teamZone = document.getElementById('team-zone');
const output = document.getElementById('output');

// Allows champions to be dragged around
champions.forEach(champion => {
    champion.dx = 0;
    champion.dy = 0;

    champion.addEventListener('pointerdown', function(event) {
        champion.setPointerCapture(event.pointerId);
        champion.classList.add('dragging');

        champion.startX = event.clientX - champion.dx;
        champion.startY = event.clientY - champion.dy;
    });

    champion.addEventListener('pointermove', function(event) {
        if (!champion.hasPointerCapture(event.pointerId)) {
            return;
        }

        champion.dx = event.clientX - champion.startX;
        champion.dy = event.clientY - champion.startY;

        champion.style.left = champion.dx + 'px';
        champion.style.top = champion.dy + 'px';
    });

    champion.addEventListener('pointerup', function() {
        champion.classList.remove('dragging');
        document.getElementById('showBtn').click();
    });
});

// Moves all champions back to their starting positions
function resetPositions() {
    champions.forEach(champion => {
        champion.dx = 0;
        champion.dy = 0;

        champion.style.left = '0px';
        champion.style.top = '0px';
    });
}

// Checks if a champion is inside the team area
function isInTeamZone(champion) {
    const zonePosition = teamZone.getBoundingClientRect();
    const champPosition = champion.getBoundingClientRect();

    return !(
        champPosition.right < zonePosition.left ||
        champPosition.left > zonePosition.right ||
        champPosition.bottom < zonePosition.top ||
        champPosition.top > zonePosition.bottom
    );
}

// Gets all champions currently placed in the team
function getCurrentTeam() {
    let team = [];

    champions.forEach(champion => {
        if (!champion.classList.contains('hidden') &&
            isInTeamZone(champion)) {
            team.push(champion.dataset.name);
        }
    });

    return team;
}

// Show button - displays champions and their traits
document.getElementById('showBtn').onclick = function() {
    const team = getCurrentTeam();
    let traitCounts = {};

    const allTraits = [
        gameData.classTraits,
        gameData.originTraits
    ];

    allTraits.forEach(traitGroup => {
        for (let trait in traitGroup) {
            let members = traitGroup[trait];

            team.forEach(name => {
                if (members.includes(name)) {
                    if (!traitCounts[trait]) {
                        traitCounts[trait] = 0;
                    }

                    traitCounts[trait]++;
                }
            });
        }
    });

    const sortedTraits = Object.entries(traitCounts);
    sortedTraits.sort((a, b) => b[1] - a[1]);


    let result = '';

    result += 'Champions: ' + team.join(', ') + '\n';

    result += '\nTrait Counts:\n';


    sortedTraits.forEach(trait => {
        result += trait[0] + ': ' + trait[1] + '\n';
    });

    output.textContent = result;
};

// Exclude button - hides champions with selected origins
document.getElementById('excludeBtn').onclick = function() {
    resetPositions();

    champions.forEach(champion => {
        champion.classList.remove('hidden');
    });

    const selectedOrigins = document.querySelectorAll('.excl:checked');

    selectedOrigins.forEach(checkbox => {
        const excludedChampions = gameData.originTraits[checkbox.value];

        excludedChampions.forEach(name => {
            const champion = Array.from(champions).find(champ => {
                return champ.dataset.name === name;
            });

            if (champion) {
                champion.classList.add('hidden');
            }
        });
    });
};

// Reset button - clears everything
document.getElementById('resetBtn').onclick = function() {
    resetPositions();

    champions.forEach(champion => {
        champion.classList.remove('hidden');
    });

    document.querySelectorAll('.excl').forEach(checkbox => {
        checkbox.checked = false;
    });

    output.textContent = '';
};

// Saved team compositions
const message = document.getElementById('msg');
const savedComps = document.getElementById('comps');

// Sends requests to the PHP file
async function sendRequest(action, data) {
    let options;

    if (data) {
        options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        };
    }

    const response = await fetch('comps.php?action=' + action, options);
    const result = await response.json();

    if (!response.ok) {
        throw new Error(result.error || 'Request failed');
    }

    return result;
}

// Loads a saved team into the team area
function loadTeam(teamNames) {
    resetPositions();

    champions.forEach(champion => {
        champion.classList.remove('hidden');
    });

    const zonePosition = teamZone.getBoundingClientRect();

    teamNames.forEach((name, index) => {
        const champion = Array.from(champions).find(champ => {
            return champ.dataset.name === name;
        });

        if (!champion) {
            return;
        }

        const champPosition = champion.getBoundingClientRect();

        const column = index % 15;
        const row = Math.floor(index / 15);

        champion.dx = zonePosition.left + 10 + column * 58
                      - champPosition.left;

        champion.dy = zonePosition.top + 10 + row * 63
                      - champPosition.top;

        champion.style.left = champion.dx + 'px';
        champion.style.top = champion.dy + 'px';
    });
}

// Updates the list of saved team compositions
async function refreshSavedComps() {
    const comps = await sendRequest('list');

    savedComps.innerHTML = '';

    comps.forEach(comp => {
        const listItem = document.createElement('li');

        const compName = document.createElement('span');
        compName.className = 'cname';
        compName.textContent = comp.name;

        const compChampions = document.createElement('span');
        compChampions.className = 'cchamps';
        compChampions.textContent = comp.champions.join(', ');

        const loadButton = document.createElement('button');
        loadButton.textContent = 'Load';

        loadButton.onclick = function() {
            loadTeam(comp.champions);
        };

        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Delete';

        deleteButton.onclick = async function() {
            await sendRequest('delete', { id: comp.id });
            refreshSavedComps();
        };

        listItem.append(
            compName,
            compChampions,
            loadButton,
            deleteButton
        );

        savedComps.append(listItem);
    });
}

// Save button - saves the current team
document.getElementById('saveBtn').onclick = async function() {
    const team = getCurrentTeam();
    const nameInput = document.getElementById('compName');

    try {
        await sendRequest('save', {
            name: nameInput.value,
            champions: team
        });

        message.textContent = 'Saved!';
        nameInput.value = '';

        refreshSavedComps();
    }
    catch (error) {
        message.textContent = error.message;
    }
};

// Display saved compositions when the page loads
refreshSavedComps();
