/**
 * Zeppelin Home - Page Redirect Script
 * 
 * Handles automatic redirection from the root page to the main documentation.
 * This script provides JavaScript-based redirection as a fallback to the HTML meta refresh.
 * 
 * @author Zeppelin Home Team
 * @version 1.0.0
 */

(function() {
    'use strict';
    
    /**
     * Configuration for redirect behavior
     */
    const REDIRECT_CONFIG = {
        targetPath: './docs/',
        delay: 0, // Immediate redirect
        fallbackDelay: 3000 // Fallback delay if immediate redirect fails
    };
    
    /**
     * Perform the redirect to the target path
     * @param {string} path - The path to redirect to
     */
    function redirectTo(path) {
        try {
            // Primary redirect method
            window.location.href = path;
        } catch (error) {
            console.warn('Primary redirect failed, using fallback:', error);
            // Fallback redirect method
            setTimeout(() => {
                window.location.replace(path);
            }, REDIRECT_CONFIG.fallbackDelay);
        }
    }
    
    /**
     * Initialize the redirect process
     */
    function initRedirect() {
        // Check if we're already on the target page to prevent redirect loops
        if (window.location.pathname.includes('/docs/')) {
            return;
        }
        
        // Log redirect for debugging
        console.log('Zeppelin Home: Redirecting to main documentation...');
        
        // Perform redirect with configured delay
        if (REDIRECT_CONFIG.delay === 0) {
            redirectTo(REDIRECT_CONFIG.targetPath);
        } else {
            setTimeout(() => {
                redirectTo(REDIRECT_CONFIG.targetPath);
            }, REDIRECT_CONFIG.delay);
        }
    }
    
    /**
     * Wait for DOM to be ready, then initialize redirect
     */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initRedirect);
    } else {
        initRedirect();
    }
    
    // Expose configuration for external access if needed
    window.ZeppelinRedirect = {
        config: REDIRECT_CONFIG,
        redirectTo: redirectTo
    };
    
})();