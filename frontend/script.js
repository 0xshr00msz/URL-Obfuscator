// AWS API
// const API_URL = 'https://your-api-id.execute-api.region.amazonaws.com/prod';

const API_URL = 'http://localhost:5500'

async function submitWord() {
    const word = document.getElementById("urlInput").value;
    await fetch(API_URL + '/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ word: word })
    });
    loadWords();
}

async function loadWords() {
    const res = await fetch(API_URL + '/dashboard');
    const words = await res.json();
    const list = document.getElementById("urlList");
    list.innerHTML = '';
    words.forEach(w => {
        const li = document.createElement("li");
        li.innerText = w;
        list.appendChild(li);
    });
}

window.onload = loadWords;