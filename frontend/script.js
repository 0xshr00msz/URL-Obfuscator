const apiUrl = window.APP_CONFIG.APIURL;

document.addEventListener("DOMContentLoaded", loadEntries);
document.getElementById("loadBtn").addEventListener("click", loadEntries);

async function loadEntries() {
  const container = document.getElementById("entries");
  container.innerHTML = "<p>Loading entries...</p>";

  try {
    const response = await fetch(apiUrl, { method: "GET" });
    // Error handling for response
    if (!response.ok) {
      container.innerHTML = `<p class="error">Error: ${data.error || "Unknown"}</p>`;
      return;
    }
    // Gets the data if the response is ok
    const data = await response.json();
    console.log(data);

    if (Array.isArray(data) && data.length > 0) {
      container.innerHTML = data
        .map(
          (item) => `
          <div class="entry">
            <pre>${JSON.stringify(item, null, 2)}</pre>
          </div>
        `
        )
        .join("");
    } else {
      container.innerHTML = "<p>No entries found.</p>";
    }
  } catch (err) {
    container.innerHTML = `<p class="error">Server error: ${err.message}</p>`;
  }
}
