import React from 'react';
import RushingPlayers from './RushingPlayers';

function Application() {
  return (
    <div className="Application">
      <div className="topbar">
        <h2>The Score</h2>
        <span>NFL - Rushing Players</span>
      </div>
      <main>
        <RushingPlayers />
      </main>
    </div>
  );
}

export default Application;
