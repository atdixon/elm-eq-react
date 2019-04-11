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

export default GroceryItem;