import React from 'react';
import RushingPlayers from './RushingPlayers';

function Application() {
  return (
    <div className="Application">
      <div className="topbar">
        <h2>The Score - NFL Rushing Players</h2>
      </div>
      <main>
        <RushingPlayers />
      </main>
    </div>
  );
}

export default Application;
