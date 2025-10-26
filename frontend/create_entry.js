// HTML Button for POST request
const postBtn = document.getElementById('postBtn')

postBtn.addEventListener('click', async () => {
    const input = document.getElementById('entryInput')
    const entryText = input.value.trim()

    if (!entryText) {
        alert("Input field must not be empty.");
        console.log("No input detected.")
        return;
    }

    // POST the input into the DynamoDB
    try{
        const api_url = window.APP_CONFIG.API_URL
        const response = await fetch(`${api_url}/urls`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({content: entryText})
        });

        if (response.ok){
            alert("Entry submitted!");
            input.value = '';
        } else {
            alert("Failed to add entry");
        }
    } catch (err) {
        console.log(err);
        alert("Error adding entry.");
        // Clear input field for cleanliness
        input.value = '';
    }
});