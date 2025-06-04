document.addEventListener('DOMContentLoaded', function() {
    const songsSection = document.getElementById('songs');
    const template = document.getElementById('song-template');
    const searchInput = document.getElementById('search-input');
    
    let allSongs = [];

    function renderSongs(songs) {
        songsSection.innerHTML = '';
        songsSection.appendChild(template);

        if (songs.length === 0) {
            songsSection.innerHTML += '<div class="text-red-400 text-center">Nincs találat.</div>';
            
            return;
        }

        songs.forEach(song => {
            const clone = template.firstElementChild.cloneNode(true);
            if (song.image && song.image.trim() !== "") {
                clone.querySelector('img').src = `img/${song.image}.png`;
            } else {
                clone.querySelector('img').src = 'img/placeholder.png';
            }
            
            clone.querySelector('img').alt = song.title || 'Album borító';
            clone.querySelector('.font-semibold').textContent = song.title;
            clone.querySelector('.artist-name').textContent = song.artist;
            clone.querySelector('.text-gray-300.text-xs').textContent = song.duration;
            songsSection.appendChild(clone);
        });
    }

    function fetchAndRenderSongs() {
        fetch('backend/data.php')
            .then(response => response.json())
            .then(data => {
                allSongs = data;
                renderSongs(allSongs);
        }).catch(err => {
            songsSection.innerHTML = `<div class="text-red-500 text-center">Nem sikerült betölteni a dalokat.<br><span class="text-xs">${err}</span></div>`;
        });
    }

    searchInput.addEventListener('input', function() {
        const query = searchInput.value.trim().toLowerCase();

        if (!query) {
            renderSongs(allSongs);
            return;
        }

        const filtered = allSongs.filter(song => song.title.toLowerCase().includes(query));
        
        if (filtered.length === 0) {
            renderSongs(allSongs);
        } else {
            renderSongs(filtered);
        }
    });

    fetchAndRenderSongs();
});