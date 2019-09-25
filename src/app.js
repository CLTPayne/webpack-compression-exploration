import React from 'react';
import get from 'lodash-es/get';

const appData = {
    panda: {
        height: "10cm",
        weight: ["1kg?", "30kg", "21kg"]
    },
    lion: {
        height: "30cm",
        weight: "10kg"
    },
    elephant: {
        height: "40cm",
        weight: "50kg"
    },
    mouse: {
        height: "1cm",
        weight: "0.2kg"
    }
}

const App = () => {
    const pandaWeight = get(appData, ["panda", "weight", "1"])
    return (
        <div>
            Hello, did you know that pandas can weigh {pandaWeight}? Interesting huh?
        </div>
    )
}

export default App;