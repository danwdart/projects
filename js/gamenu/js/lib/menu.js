export const menu = obj => `
    <div class="menu" id="${obj.id}">
        ${obj.items.map(item => `
            <div
                class="menuitem"
                ${item.action ? `data-action="${item.action}"` : ''}
                ${item.menu ? `data-menu="${item.menu}"` : ''}
            >
                ${item.name}
            </div>
        `).join('<br>')}
    </div>
`;