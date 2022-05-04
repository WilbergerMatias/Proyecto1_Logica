import React from 'react';
import Square from './Square';
import Game from './Game'

class Board extends React.Component {
    render() {
        return (
            <div className="board">
                {this.props.grid.map((row, i) =>
                    row.map((cell, j) =>
                        <Square
                            value={cell}
                            key={i + "." + j}
                            //onClick={() => Game.handleClickprincipal(i,j)}
                        />
                    )
                )}
            </div>
        );
    }
}

export default Board;