import React from 'react';

const tableMap = [
  { label: "Player", key: "name" },
  { label: "Team"  , key: "team" },
  { label: "Pos"   , key: "position" },
  { label: "Lng"   , key: "rushing_longest_rush", sortable: true },
  { label: "TD"    , key: "rushing_total_touchdowns", sortable: true },
  { label: "Yds"   , key: "rushing_total_yards", sortable: true },
  { label: "Att/G" , key: "rushing_attempts_per_game" },
  { label: "Att"   , key: "rushing_attempts" },
  { label: "Avg"   , key: "rushing_average_yards" },
  { label: "Yds/G" , key: "rushing_yards_per_game" },
  { label: "1st"   , key: "rushing_first_downs" },
  { label: "1st%"  , key: "rushing_first_down_percent" },
  { label: "20+"   , key: "rushing_plus_20_yards" },
  { label: "40+"   , key: "rushing_plus_40_yards" },
  { label: "FUM"   , key: "rushing_fumbles" }
]

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
      <th key={column.key}>
        <button
            onClick={toggleSort}
          > Toggle </button>
        {column.label}
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
