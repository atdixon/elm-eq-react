import React from 'react'

class GroceryItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {expanded: false};
    }

    render() {
        return <div className={'item'}
            onClick={() => this.setState({expanded: !this.state.expanded})}>
            {this.props.item.item}
            <br/>
            {this.state.expanded ? this.props.item.note : null}
        </div>;
    }
}

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