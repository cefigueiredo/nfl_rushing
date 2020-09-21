import React, {useState, useEffect, useReducer} from 'react';
import axios from 'axios';
import { stringifyUrl } from 'query-string';
import PlayersTable from './PlayersTable';
import SearchPlayers from './SearchPlayers';

function prepareUrl(path, params) {
  return stringifyUrl({
    url: path,
    query: { query: params.name, per_page: 10, page: params.page}
  })
}

function fetchPlayers(params) {
  const url = prepareUrl('/api/players', params)

  return axios.get(url)
}


function RushingPlayers() {
  const [searchedName, setSearchedName] = useState('')
  const [players, setPlayers] = useState([])
  const [isLoading, setIsLoading] = useState(true)
  const [currentPage, setCurrentPage] = useState(0)

  const [pagination, setPagination] = useReducer(trackPagination, {
    current: currentPage,
    has_next: true,
    has_previous: false})

  function searchCallback(value) {
    setSearchedName(value)
  }

  function paginationCallback(value) {
    if (value == "next" && pagination.has_next) {
      setCurrentPage(currentPage + 1)
    }

    if (value == "previous" && pagination.has_previous) {
      setCurrentPage(currentPage - 1)
    }

  }

  function trackPagination(previousState, update) {
    let has_next = update.total_pages > update.current + 1
    let has_previous = update.current - 1 > -1

    return {...previousState, ...update, has_next: has_next, has_previous: has_previous}
  }

  useEffect(() => {
    setIsLoading(true);
    fetchPlayers({name: searchedName, page: currentPage})
      .then(({data}) => {
        setPlayers(data.data);
        let params = data.params
        console.log(data)
        setPagination({current: params.page, total_pages: data.total / params.per_page});
        setIsLoading(false)
      })
  }, [searchedName, currentPage])

  return (
    <>
      <SearchPlayers searchedName={searchedName} searchCallback={searchCallback} />
      <PlayersTable players={players} />
      <div>
        <button onClick={() => paginationCallback("previous") } >Previous</button>
        <button onClick={() => paginationCallback("next")} >Next</button>
      </div>
    </>
  );
}

export default RushingPlayers;
