import './main.css';
import logoPath from './logo.svg';
const { App } = require('./App.elm');

var app = App.embed(document.getElementById('root'), logoPath);
app.ports.whereami.subscribe(function([lng, lat]){
    console.log("hi", lng, lat);
    map.setCenter({lng, lat});
    marker.setPosition({lng, lat});
});
