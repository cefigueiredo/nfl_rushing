import React, {useState, useEffect, useReducer} from 'react';
import axios from 'axios';
import { stringifyUrl } from 'query-string';
import PlayersTable from './PlayersTable';
import SearchPlayers from './SearchPlayers';

function prepareUrl(path, params) {
  return stringifyUrl({
    url: path,
    query: {
      query: params.name,
      per_page: 10,
      page: params.page,
      sort_by: params.sort_by,
      is_asc: params.is_ascending
    }
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

  const [pagination, setPagination] = useReducer(trackPaginationChanges, {
    current: currentPage,
    has_next: true,
    has_previous: false})

  const [sortedColumn, setSortedColumn] = useState("")
  const [isSortAscending, setIsSortAscending] = useState("")

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

  function trackPaginationChanges(previousState, update) {
    let has_next = update.total_pages > update.current + 1
    let has_previous = update.current - 1 > -1

    return {...previousState, ...update, has_next: has_next, has_previous: has_previous}
  }

  function sortCallback(criteria) {
    setSortedColumn(criteria.sort_by)
    setIsSortAscending(criteria.is_ascending)
  }

  useEffect(() => {
    setIsLoading(true);
    fetchPlayers({
            name: searchedName,
            page: currentPage,
            sort_by: sortedColumn,
            is_ascending: isSortAscending
        }
      )
      .then(({data}) => {
        let params = data.params

        setPlayers(data.data);
        setPagination({current: params.page, total_pages: data.total / params.per_page});
        setIsLoading(false)
      })
  }, [searchedName, currentPage, sortedColumn, isSortAscending])

  return (
    <>
      <SearchPlayers searchedName={searchedName} searchCallback={searchCallback} />
      <PlayersTable players={players}
                    sortCallback={sortCallback}
                    sortedColumn={sortedColumn}
                    isSortAscending={isSortAscending} />
      <div>
        <button onClick={() => paginationCallback("previous") } >Previous</button>
        <button onClick={() => paginationCallback("next")} >Next</button>
      </div>
    </>
  );
}

export default RushingPlayers;
