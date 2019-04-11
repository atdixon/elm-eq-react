import React from 'react'
import ReactDOM from 'react-dom'
import data from './data.json'
import AppReact from './componentized/App.jsx'
import AppElm from './componentized/App.elm'

ReactDOM.render(
    <AppReact items={data.items}/>, document.getElementById('app-react'));

AppElm.Elm.App.init(
    {flags: {items: data.items}, node: document.getElementById('app-elm')});