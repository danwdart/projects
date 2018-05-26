/* eslint-disable */
const GROUP_NODES = `nodes`,
    GROUP_EDGES = `edges`;

export const cy = cytoscape(
    {
        container: document.querySelector(`div`),
        style: [
            {
                selector: `node`,
                style: {
                    content: `data(id)`
                }
            }
        ]
    }
);

export function addNode(id)
{
    cy.add(
        {
            group: GROUP_NODES,
            data: {
                id
            }
        }
    );
}

export function addEdge(id1, id2)
{
    cy.add(
        {
            group: GROUP_EDGES,
            data: {
                id: `${id1}->${id2}`,
                source: id1,
                target: id2
            }
        }
    );
}
export function refresh()
{
    cy.layout({name: `cose`}).run();
}
