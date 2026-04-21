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
    async getMetrics(days = null) {
        try {
            const url = days ? `${API_CONFIG.BASE_URL}/metrics?days=${days}` : `${API_CONFIG.BASE_URL}/metrics`;
            const response = await fetch(url, {
                headers: { 'Authorization': this.getToken() }
            });
            if (!response.ok) throw new Error('Metric fetch failed');
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    /**
     * Fetch analytics data
     */
    async getAnalytics(days = null) {
        try {
            const url = days ? `${API_CONFIG.BASE_URL}/analytics?days=${days}` : `${API_CONFIG.BASE_URL}/analytics`;
            const response = await fetch(url, {
                headers: { 'Authorization': this.getToken() }
            });
            if (!response.ok) throw new Error('Analytics fetch failed');
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    /**
     * Fetch all interactions
     */
    async getInteractions(days = null) {
        try {
            const url = days ? `${API_CONFIG.BASE_URL}/interactions?days=${days}` : `${API_CONFIG.BASE_URL}/interactions`;
            const response = await fetch(url, {
                headers: { 'Authorization': this.getToken() }
            });
            if (!response.ok) throw new Error('Interactions fetch failed');
            return await response.json();
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    /**
     * Export data as CSV
     */
    async exportInteractions(days = null) {
        try {
            const data = await this.getInteractions(days);
            if (!data || data.length === 0) {
                alert("No hay datos para exportar.");
                return;
            }

            const headers = ["ID", "User ID", "Message", "Response", "Intent", "Rating", "Timestamp"];
            const csvContent = [
                headers.join(","),
                ...data.map(item => [
                    item.id,
                    item.user_id,
                    `"${(item.message_content || '').replace(/"/g, '""')}"`,
                    `"${(item.response_content || '').replace(/"/g, '""')}"`,
                    item.intent,
                    item.rating || 'N/A',
                    item.timestamp
                ].join(","))
            ].join("\n");

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement("a");
            link.setAttribute("href", url);
            link.setAttribute("download", `horizonte_audit_${new Date().toISOString().split('T')[0]}.csv`);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } catch (error) {
            alert("Error al exportar reporte: " + error.message);
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
