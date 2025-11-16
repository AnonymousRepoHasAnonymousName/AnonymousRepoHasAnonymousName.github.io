// Remove theme switcher button
(function() {
    function removeThemeSwitcher() {
        // Try multiple selectors to find the theme switcher button
        const selectors = [
            'button.theme-switch-button',
            '.theme-switch-button',
            'button[aria-label="Color mode"]',
            '.pst-navbar-icon.theme-switch-button'
        ];
        
        for (const selector of selectors) {
            const buttons = document.querySelectorAll(selector);
            buttons.forEach(button => {
                button.style.display = 'none';
                button.style.visibility = 'hidden';
                button.remove();
            });
        }
    }
    
    // Run immediately
    removeThemeSwitcher();
    
    // Also run after DOM is fully loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', removeThemeSwitcher);
    } else {
        removeThemeSwitcher();
    }
    
    // Run after a short delay to catch dynamically loaded elements
    setTimeout(removeThemeSwitcher, 100);
    setTimeout(removeThemeSwitcher, 500);
})();

