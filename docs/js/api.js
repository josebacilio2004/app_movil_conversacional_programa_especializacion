/**
 * Horizonte Web System - API Service
 */

const API_CONFIG = {
    // URL de producción en Render
    BASE_URL: 'https://horizonte-backend.onrender.com/api',
    HEALTH_URL: 'https://horizonte-backend.onrender.com/health'
};

const HorizonteAPI = {
    /**
     * Fetch aggregated metrics for the dashboard
     */
    async getMetrics() {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}/metrics`);
            if (!response.ok) throw new Error('Metric fetch failed');
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    /**
     * Login credentials validation
     */
    async login(email, code) {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email, code })
            });
            const data = await response.json();
            if (data.success) {
                localStorage.setItem('auth_token', data.token);
                localStorage.setItem('user', JSON.stringify(data.user));
            }
            return data;
        } catch (error) {
            console.error('Login API Error:', error);
            return { success: false, error: 'Servidor no disponible' };
        }
    },

    /**
     * Get stored token
     */
    getToken() {
        return localStorage.getItem('auth_token');
    },

    /**
     * Logout and clear session
     */
    logout() {
        localStorage.removeItem('auth_token');
        localStorage.removeItem('user');
        window.location.href = 'login.html';
    },

    /**
     * Log a new chat interaction
     */
    async logChat(userId, message, isUser, type = 'general') {
        try {
            const response = await fetch(`${API_CONFIG.BASE_URL}/chat`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userId, message, isUser, type })
            });
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            return { success: false, error };
        }
    },

    /**
     * Check system health
     */
    async checkHealth() {
        try {
            const response = await fetch(API_CONFIG.HEALTH_URL);
            return await response.json();
        } catch (error) {
            return { status: 'offline', error };
        }
    }
};

// Export for use in other scripts
window.HorizonteAPI = HorizonteAPI;
