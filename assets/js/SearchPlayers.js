import React, {useRef} from 'react';
import debounce from 'lodash/debounce';


function SearchPlayers({searchedName, searchCallback}) {
  const searchRef = useRef(searchedName);

  const onChange = debounce(event => {
      searchCallback(searchRef.current.value)
  }, 300)

  return (
      <div>
        <label>
          Search Player:
          <input
            type="text"
            ref={searchRef}
            onChange={onChange} />
        </label>
      </div>
  )
}

export default SearchPlayers;
