// tests/pages/SettingsPage.js
// Page Object Model — Admin / Settings Page
// All locators isolated here; test logic never uses raw selectors

const { expect } = require('@playwright/test');

class SettingsPage {
  constructor(page) {
    this.page = page;

    // ── LOCATORS 
    // Navigation
    this.navSettings        = page.locator('a[href="settings.html"]');

    // Profile tab inputs
    this.profileTab         = page.locator('text=Profile');
    this.commissionInput    = page.locator('#commission-rate, input[id*="commission"]').first();
    this.vatRateInput       = page.locator('#vat-rate, input[id*="vat"]').first();
    this.saveProfileBtn     = page.locator('button', { hasText: /save profile/i });
    this.successToast       = page.locator('.toast-success, [class*="success"], text=Settings saved');

    // Notification tab
    this.notificationsTab   = page.locator('text=Notifications');
    this.savePrefsBtn       = page.locator('button', { hasText: /save preferences/i });
  }

  // ── ACTIONS 

  async goto() {
    await this.page.goto('https://quality-engineering-labs.vercel.app/settings.html');
    await this.page.waitForLoadState('domcontentloaded');
  }

  async updateCommissionRate(newRate) {
    await this.profileTab.click();
    await this.commissionInput.waitFor({ state: 'visible' });
    await this.commissionInput.triple_click();
    await this.commissionInput.fill(String(newRate));
    await this.saveProfileBtn.click();
  }

  async getCommissionRate() {
    await this.profileTab.click();
    await this.commissionInput.waitFor({ state: 'visible' });
    return parseFloat(await this.commissionInput.inputValue());
  }
}

module.exports = { SettingsPage };
