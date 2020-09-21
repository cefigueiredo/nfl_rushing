import React from 'react';

const tableMap = [
  { label: "Player", key: "name" },
  { label: "Team"  , key: "team" },
  { label: "Pos"   , key: "position" },
  { label: "Att/G" , key: "rushing_attempts_per_game" },
  { label: "Att"   , key: "rushing_attempts" },
  { label: "Yds"   , key: "rushing_total_yards" },
  { label: "Avg"   , key: "rushing_average_yards" },
  { label: "Yds/G" , key: "rushing_yards_per_game" },
  { label: "TD"    , key: "rushing_total_touchdowns" },
  { label: "Lng"   , key: "rushing_longest_rush" },
  { label: "1st"   , key: "rushing_first_downs" },
  { label: "1st%"  , key: "rushing_first_down_percent" },
  { label: "20+"   , key: "rushing_plus_20_yards" },
  { label: "40+"   , key: "rushing_plus_40_yards" },
  { label: "FUM"   , key: "rushing_fumbles" }
]

function PlayersTable({players}) {

  return (
      <>
        <table>
          <thead>
            <tr>
              {tableMap.map(({label}) => (
                <th key={label}>{label}</th>
              ))}
            </tr>
          </thead>
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
        </table>
      </>
  )
}

export default PlayersTable;
