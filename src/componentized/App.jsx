import React from 'react'
import GroceryItem from './ItemComponent.jsx'

class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {items: props.items};
        this.refresh = this.refresh.bind(this);
    }
    refresh() {
        fetch('/data-remote.json')
            .then(resp => resp.json())
            .then(json => this.setState({items: json.items}))
    }
    render() {
        return <div>
            <h4>Grocery List</h4>
            <button onClick={this.refresh}>reload</button>
            {this.state.items.map(t => <GroceryItem key={t.item} item={t}/>)}
        </div>;
    }
}

export default App;