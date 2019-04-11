import React from 'react'


const Heading =
    () => <h4>Grocery List</h4>;


const GroceryItem = (item, expanded, send) =>
    <div className={"item"} onClick={() => send('Toggle', item)}>
        {item.item}
        <br/>
        {expanded ? item.note : null}
    </div>;

const init = (props) =>
    ({items: props.items, expanded: new Set()});


const View = ({items, expanded, send}) =>
    <div>
        <Heading/>
        <button onClick={() => send('Reload')}>reload</button>
        {items.map(
            t => GroceryItem(t, expanded.has(t), send)
        )}
    </div>;

const update = (msg, model) => {
    switch (msg[0]) {
        case 'Toggle':
            return {
                expanded: model.expanded.delete(msg[1])
                    ? model.expanded
                    : model.expanded.add(msg[1])
            };
        case 'Reload':
            return [model,
                ['Http.get', {
                    url: '/data-remote.json',
                    expectJson: 'GotData'
                }]];
        case 'GotData':
            return {items: msg[1].items};
    }
};


class Controller extends React.Component {
    constructor(props) {
        super(props);
        this.state = init(props);
        this.runtime = this.runtime.bind(this);
        this.send = (...msg) =>
            this.setState(model => this.runtime(update(msg, model)));
    }

    runtime(update) {
        if (Array.isArray(update)) {
            switch (update[1][0]) {
                case 'Http.get':
                    fetch(update[1][1].url)
                        .then(resp => resp.json())
                        .then(json => this.send(update[1][1].expectJson, json));
            }
            return update[0];
        }
        return update;
    }

    render() {
        return <View items={this.state.items} expanded={this.state.expanded}
            send={this.send}/>;
    }
}

export default Controller;
