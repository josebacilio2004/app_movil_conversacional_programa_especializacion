const HorizonteI18n = {
    currentLang: localStorage.getItem('horizonte_lang') || 'es',

    init() {
        this.applyTranslations();
        this.setupSwitcher();
    },

    setLanguage(lang) {
        if (translations[lang]) {
            this.currentLang = lang;
            localStorage.setItem('horizonte_lang', lang);
            this.applyTranslations();
        }
    },

    applyTranslations() {
        const dict = translations[this.currentLang];
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (dict[key]) {
                if (el.tagName === 'INPUT' && el.placeholder) {
                    el.placeholder = dict[key];
                } else {
                    el.innerText = dict[key];
                }
            }
        });
        document.documentElement.lang = this.currentLang;
        
        // Update active class on switcher buttons if they exist
        document.querySelectorAll('.lang-btn').forEach(btn => {
            if (btn.getAttribute('data-lang') === this.currentLang) {
                btn.classList.add('active-lang');
            } else {
                btn.classList.remove('active-lang');
            }
        });
    },

    setupSwitcher() {
        document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                this.setLanguage(btn.getAttribute('data-lang'));
            });
        });
    }
};

document.addEventListener('DOMContentLoaded', () => HorizonteI18n.init());
