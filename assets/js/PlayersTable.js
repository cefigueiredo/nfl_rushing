import React from 'react';

const tableMap = [
  { label: "Player", key: "name" },
  { label: "Team"  , key: "team" },
  { label: "Pos"   , key: "position" },
  { label: "Lng"   , key: "rushing_longest_rush", sortable: true },
  { label: "TD"    , key: "rushing_total_touchdowns", sortable: true },
  { label: "Yds"   , key: "rushing_total_yards", sortable: true },
  { label: "Att/G" , key: "rushing_attempts_per_game", sortable: true },
  { label: "Att"   , key: "rushing_attempts", sortable: true },
  { label: "Avg"   , key: "rushing_average_yards", sortable: true },
  { label: "Yds/G" , key: "rushing_yards_per_game", sortable: true },
  { label: "1st"   , key: "rushing_first_downs", sortable: true },
  { label: "1st%"  , key: "rushing_first_down_percent", sortable: true },
  { label: "20+"   , key: "rushing_plus_20_yards", sortable: true },
  { label: "40+"   , key: "rushing_plus_40_yards", sortable: true },
  { label: "FUM"   , key: "rushing_fumbles", sortable: true }
]

function getSortableClass(column, sorted, isAscending) {
  if (column == sorted) {
    return isAscending ? 'sortable sorted-asc' : 'sortable sorted-desc'
  }

  return 'sortable'
}


function SortableColumnHeader({column, sortedColumn, isSortAscending, sortCallback}) {
  function toggleSort(event) {
    let newSortAscending = isSortAscending

    if(sortedColumn == column.key) {
      newSortAscending = !newSortAscending
    }
    else {
      newSortAscending = true
    }

    sortCallback({ sort_by: column.key, is_ascending: newSortAscending })
  }

  return(
    <>
      <th className={getSortableClass(column.key, sortedColumn, isSortAscending)} key={column.key} onClick={toggleSort}>
        {column.label}
        <div className="sort-icons">
          <i className="sort-desc"></i>
          <i className="sort-asc"></i>
        </div>
      </th>
    </>
  )
}

function TableHead({sortedColumn, isSortAscending, sortCallback}) {
  return (
      <thead>
        <tr>
          {tableMap.map((column) => (
            column.sortable
              ? <SortableColumnHeader
                    key={column.key}
                    column={column}
                    sortedColumn={sortedColumn}
                    isSortAscending={isSortAscending}
                    sortCallback={sortCallback} />
              : <th key={column.key}>{column.label}</th>
          ))}
        </tr>
      </thead>
  )
}

function TableBody({players}) {
  return (
      <tbody>
        {players.map((player) => (
          <tr key={player.name}>
            {tableMap.map(({key}) => (
              <td key={key}>
                {player[key]}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
  )
}

function PlayersTable({players, sortedColumn, isSortAscending, sortCallback}) {

  return (
      <>
        <table>
          <TableHead sortedColumn={sortedColumn}
                     isSortAscending={isSortAscending}
                     sortCallback={sortCallback}/>
          <TableBody players={players} />
        </table>
      </>
  )
}

export default PlayersTable;
