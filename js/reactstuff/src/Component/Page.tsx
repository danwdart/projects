import React, {useState, useEffect} from 'react';

import onInputChange from '../lib/onInputChange';

export default () => {
    const [name, setName] = useState('name');

    useEffect(() => {
        window.document.title = name;
    });
    
    return <article>
        <p>This is my article.</p>
        <input type="text" onChange={onInputChange(setName)} value={name}/>
        <p>Name: {name}</p>
    </article>;
};