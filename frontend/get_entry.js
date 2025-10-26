document.addEventListener("DOMContentLoaded", loadEntries);
document.getElementById("loadBtn").addEventListener("click", loadEntries);

async function loadEntries() {
  const container = document.getElementById("entries");
  container.innerHTML = "<p>Loading entries...</p>";

  try {
    const api_url = window.APP_CONFIG.API_URL;
    const response = await fetch(`${api_url}/urls`, { method: "GET" });
    
    if (!response.ok) {
      container.innerHTML = `<p class="error">Error: ${response.status}</p>`;
      return;
    }
    
    const data = await response.json();
    console.log(data);

    if (Array.isArray(data) && data.length > 0) {
      container.innerHTML = data
        .map((item) => {
          // Extract values only
          const values = Object.values(item);
          return `
            <div class="entry">
              <pre>${values}</pre>
            </div>
          `
        })
        .join("");
    } else {
      container.innerHTML = "<p>No entries found.</p>";
    }
  } catch (err) {
    container.innerHTML = `<p class="error">Server error: ${err.message}</p>`;
  }
}
