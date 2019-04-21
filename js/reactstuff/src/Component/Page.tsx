import React, {useState, useEffect} from 'react';

export default () => {
    const [name, setName] = useState('name');
    useEffect(() => {
        window.document.title = name;
    });
    return <article>
        <p>This is my article.</p>
        <input type="text" onChange={ev => setName(ev.target.value)} value={name}/>
        <p>Name: {name}</p>
    </article>;
};