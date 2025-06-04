document.addEventListener('DOMContentLoaded', function() {
    const songsSection = document.getElementById('songs');
    const template = document.getElementById('song-template');
    const searchInput = document.getElementById('search-input');
    const qualitySwitch = document.getElementById('quality-switch');
    const ctrlCover = document.getElementById('controller-cover');
    const ctrlTitle = document.getElementById('controller-title');
    const ctrlArtist = document.getElementById('controller-artist');
    const ctrlCurrent = document.getElementById('controller-current');
    const ctrlDuration = document.getElementById('controller-duration');
    const ctrlSeek = document.getElementById('controller-seek');
    const ctrlPlay = document.getElementById('controller-play');
    const ctrlPrev = document.getElementById('controller-prev');
    const ctrlNext = document.getElementById('controller-next');

    let isLossless = false;
    let allSongs = [];
    let selectedSongRow = null;
    let audio = null;
    let selectedSong = null;
    let currentSongIndex = -1;
    let languageData = {};
    let currentLanguage = 'en';



    if (qualitySwitch) {
        qualitySwitch.addEventListener('change', function() {
            isLossless = qualitySwitch.checked;

            if (selectedSongRow) {
                selectedSongRow.click();
            }
        });
    }



    function loadLanguagesAndSet() {
        const availableLangs = ['en', 'hu'];

        let browserLang = (navigator.language || navigator.userLanguage || 'en').split('-')[0];

        if (!availableLangs.includes(browserLang)) {
            browserLang = 'en';
        }
        
        currentLanguage = browserLang;

        fetch(`lang/${currentLanguage}.json`)
            .then(res => res.json())
            .then(json => {
                languageData = json;

                applyLanguage();
                fetchAndRenderSongs();
            })
            .catch(() => {
                fetch('lang/en.json')
                    .then(res => res.json())
                    .then(json => {
                        languageData = json;

                        applyLanguage();
                        fetchAndRenderSongs();
                    });
            });
    }



    function applyLanguage() {
        document.querySelectorAll('[data-lang]').forEach(el => {
            const key = el.getAttribute('data-lang');

            if (languageData[key]) {
                el.textContent = languageData[key];
            }
        });
    }



    function formatTime(sec) {
        if (!sec || isNaN(sec)) {
            return '0:00';
        }

        sec = Math.floor(sec);

        const m = Math.floor(sec / 60);
        const s = sec % 60;

        return `${m}:${s.toString().padStart(2, '0')}`;
    }



    function formatTimeFromDb(dbTime) {
        if (!dbTime) {
            return '0:00';
        }

        const parts = dbTime.split(':');

        if (parts.length >= 2) {
            return `${parts[0]}:${parts[1].padStart(2, '0')}`;
        }

        return dbTime;
    }



    function renderSongs(songs) {
        songsSection.innerHTML = '';

        if (songs.length === 0) {
            songsSection.innerHTML += `<div class="text-red-400 text-center">${languageData['no_results'] || 'Nincs találat.'}</div>`;

            return;
        }

        songs.forEach((song, idx) => {
            const clone = template.firstElementChild.cloneNode(true);

            clone.classList.add('song-row');

            if (song.image && song.image.trim() !== "") {
                clone.querySelector('img').src = `img/songs/${song.image}.png`;
            } else {
                clone.querySelector('img').src = 'img/placeholder.png';
            }

            clone.querySelector('img').alt = song.title || (languageData['album_cover'] || 'Album borító');

            const titleDiv = clone.querySelector('.font-semibold');

            titleDiv.textContent = song.title;

            if (song.explicit == 1 || song.explicit === "1") {
                const eBadge = document.createElement('span');

                eBadge.textContent = 'E';
                eBadge.className = 'ml-2 px-1 py-0 rounded bg-gray-700 text-white text-[10px] font-bold align-middle cursor-pointer';
                eBadge.title = languageData['explicit'] || 'Eröszakos zene';
                eBadge.style.position = 'relative';
                eBadge.style.top = '-2px';

                titleDiv.appendChild(eBadge);
            }

            clone.querySelector('.artist-name').textContent = song.artist;
            clone.querySelector('.text-gray-300.text-xs').textContent = formatTimeFromDb(song.duration);

            const rightControls = clone.querySelector('.flex.items-center.ml-2');

            if (rightControls) {
                const oldWarn = rightControls.querySelector('.song-warning');

                if (oldWarn) {
                    oldWarn.remove();
                }

                let warnIcon = null;
                let warnColor = '';
                let warnTitle = '';

                if (!song.image || song.image.trim() === "") {
                    warnColor = 'text-red-500';
                    warnTitle = languageData['no_file'] || 'Ennek a zenének nincsen fájlja';
                    warnIcon = `<i class="fa fa-exclamation-triangle song-warning ${warnColor} ml-2" title="${warnTitle}"></i>`;
                } else if (typeof song.hasNormal !== "undefined" && typeof song.hasLossless !== "undefined") {
                    let missingNormal = song.hasNormal === false;
                    let missingLossless = song.hasLossless === false;

                    if (missingNormal && missingLossless) {
                        warnColor = 'text-red-500';
                        warnTitle = languageData['no_file'] || 'Ennek a zenének nincsen fájlja';
                        warnIcon = `<i class="fa fa-exclamation-triangle song-warning ${warnColor} ml-2" title="${warnTitle}"></i>`;
                    } else if (missingNormal || missingLossless) {
                        warnColor = 'text-yellow-400';
                        warnTitle = missingNormal ? (languageData['no_normal_file'] || 'Ennek a zenének nincsen normál fájlja') : (languageData['no_lossless_file'] || 'Ennek a zenének nincsen lossless fájlja');
                        warnIcon = `<i class="fa fa-exclamation-triangle song-warning ${warnColor} ml-2" title="${warnTitle}"></i>`;
                    }
                }

                if (warnIcon) {
                    rightControls.insertAdjacentHTML('afterbegin', warnIcon);
                }
            }

            clone.addEventListener('click', function() {
                if (selectedSongRow) {
                    selectedSongRow.classList.remove('selected-song');
                }

                clone.classList.add('selected-song');

                selectedSongRow = clone;
                selectedSong = song;
                currentSongIndex = idx;

                if (audio) {
                    audio.pause();
                    audio = null;
                }

                if (song.image && song.image.trim() !== "") {
                    const folder = song.image;
                    const file = isLossless ? "lossless.flac" : "normal.aac";
                    const path = `songs/${folder}/${file}`;

                    audio = new Audio(path);

                    audio.addEventListener('loadedmetadata', function() {
                        ctrlSeek.max = Math.floor(audio.duration || 0);
                        ctrlSeek.value = 0;
                        ctrlCurrent.textContent = '0:00';

                        audio.play();
                    });

                    audio.addEventListener('timeupdate', function() {
                        ctrlCurrent.textContent = formatTime(audio.currentTime);
                        ctrlSeek.value = Math.floor(audio.currentTime || 0);
                    });

                    audio.addEventListener('ended', function() {
                        ctrlPlay.innerHTML = `<i class="fa fa-play"></i>`;
                    });
                }

                updateController(song, idx);
            });

            songsSection.appendChild(clone);
        });
    }

    
    function updateController(song, idx) {
        if (!song) {
            return;
        }

        ctrlCover.src = song.image && song.image.trim() !== "" ? `img/songs/${song.image}.png` : 'img/placeholder.png';
        ctrlTitle.textContent = song.title || '';
        ctrlArtist.textContent = song.artist || '';
        ctrlCurrent.textContent = '0:00';
        ctrlDuration.textContent = formatTimeFromDb(song.duration);
        ctrlSeek.value = 0;
        ctrlSeek.max = 100;
        ctrlPlay.innerHTML = `<i class="fa fa-pause"></i>`;
    }


    ctrlPlay.addEventListener('click', function() {
        if (!audio) {
            return;
        }

        if (audio.paused) {
            audio.play();

            ctrlPlay.innerHTML = `<i class="fa fa-pause"></i>`;
        } else {
            audio.pause();

            ctrlPlay.innerHTML = `<i class="fa fa-play"></i>`;
        }
    });


    ctrlPrev.addEventListener('click', function() {
        if (currentSongIndex > 0) {
            document.querySelectorAll('.song-row')[currentSongIndex - 1].click();
        }
    });


    ctrlNext.addEventListener('click', function() {
        if (currentSongIndex < allSongs.length - 1) {
            document.querySelectorAll('.song-row')[currentSongIndex + 1].click();
        }
    });


    ctrlSeek.addEventListener('input', function() {
        if (audio && audio.duration) {
            audio.currentTime = ctrlSeek.value;
        }
    });



    function fetchAndRenderSongs() {
        fetch('backend/songdata.php')
            .then(response => response.json())
            .then(data => {
                allSongs = data;
                renderSongs(allSongs);
            }).catch(err => {
                songsSection.innerHTML = `<div class="text-red-500 text-center">${languageData['load_error'] || 'Nem sikerült betölteni a dalokat.'}<br><span class="text-xs">${err}</span></div>`;
            });
    }



    searchInput.addEventListener('input', function() {
        const query = searchInput.value.trim().toLowerCase();

        if (!query) {
            renderSongs(allSongs);

            return;
        }

        const filtered = allSongs.filter(song =>
            (song.title && song.title.toLowerCase().includes(query)) ||
            (song.artist && song.artist.toLowerCase().includes(query))
        );

        renderSongs(filtered);
    });

    loadLanguagesAndSet();
});