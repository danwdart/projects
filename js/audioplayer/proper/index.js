const audio = document.querySelector(`#player`),
    tracks = document.querySelector(`#tracks`),
    tracksItems = Array.from(tracks.children),
    CLASS_ACTIVE = `active`,
    CLASS_PAUSED = `paused`,
    SELECTOR_ACTIVE = `.${CLASS_ACTIVE}`,
    SELECTOR_LINK = `a`,
    SELECTOR_ACTIVE_LINK = `${SELECTOR_ACTIVE} ${SELECTOR_LINK}`,
    ATTR_URL = `href`,
    selectActive = () => {
        audio.src = tracks.querySelector(SELECTOR_ACTIVE_LINK)
            .getAttribute(ATTR_URL);
    },
    deselectAll = () => tracksItems.forEach(track => track.classList.remove(CLASS_ACTIVE)),
    nextTrack = () => (
        tracks.querySelector(SELECTOR_ACTIVE).nextElementSibling ||
      tracks.children[0]
    ).classList.add(CLASS_ACTIVE);
  
/*
  audio.addEventListener(
    `play`,
    event => {
      if (!audio.src) {
        if (!tracks.querySelector(SELECTOR_ACTIVE)) {
          tracks.children[0].classList.add(CLASS_ACTIVE);
        }
        selectActive();
      }
    }
  );
  */

audio.addEventListener(
    `ended`,
    () => {
        deselectAll();
        nextTrack();
        selectActive();
        audio.play();
    }
);

tracksItems.forEach(listItem =>
    listItem.querySelector(SELECTOR_LINK).addEventListener(
        `click`,
        event => {
            event.preventDefault();
            if (!listItem.classList.contains(CLASS_ACTIVE)) {
                deselectAll();
                listItem.classList.add(CLASS_ACTIVE);
                selectActive();
                audio.play();
            } else {
                listItem.classList.toggle(CLASS_PAUSED);
                audio.pause();
            }
        }
    )
);