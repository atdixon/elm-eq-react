import React from 'react'

class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {items: props.items, expanded: new Set()}
        this.refresh = this.refresh.bind(this);
    }
    toggle(event, item) {
        if (event.shiftKey.valueOf())
            this.setState(prev => ({
                expanded: prev.expanded.delete(item)
                    ? prev.expanded
                    : prev.expanded.add(item)
            }));
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
            {this.state.items.map(t =>
                <div className={'item'} onClick={(e) => this.toggle(e, t)} key={t.item}>
                    {t.item}
                    <br/>
                    {this.state.expanded.has(t) ? t.note : null}
                </div>)}
        </div>;
    }
}

export default App;