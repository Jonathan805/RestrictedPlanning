const targets = [
        {
            "id": 1,
            "name": "Target 1",
            "latitude": "21",
            "longitude": "23",
            "elevation": "1 MIL",
            "successRate": "0.25"
        },
        {
            "name": "Target 2",
            "latitude": "fghfgh",
            "longitude": "fghfg",
            "elevation": "fghfgh",
            "successRate": "fgh",
            "id": 2
        },
        {
            "name": "Target 3",
            "latitude": "sdfsd",
            "longitude": "sdfsd",
            "elevation": "sdfsd",
            "successRate": "sdfdsf",
            "id": 3
        }
]

const Targets = () => {
    return (
        <>
            {targets.map((target) => (
                <h3 key={target.id}>{target.name}</h3>
            ))}
        </>
    )
}

export default Targets