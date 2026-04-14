

const { expect } = require('@playwright/test');

class MerchantDashboardPage {
  constructor(page) {
    this.page = page;

    // ── LOCATORS 
    // Wallet / commission info bar at top of sell page
    this.walletBalance      = page.locator('text=Wallet:').locator('..').locator('strong').first();
    this.commissionDisplay  = page.locator('text=Commission Rate:').locator('..').locator('strong');

    // Sell form fields
    this.customerPhoneInput = page.locator('#customer-phone, input[placeholder*="phone" i]').first();
    this.customerNameInput  = page.locator('#customer-name, input[placeholder*="name" i]').first();
    this.productSelect      = page.locator('#product-type, select[id*="product"]').first();
    this.confirmCheckbox    = page.locator('input[type="checkbox"]').first();
    this.processSaleBtn     = page.locator('button', { hasText: /process sale/i });

    // Commission preview in sale summary panel
    this.commissionPreview  = page.locator('.sale-summary [class*="commission"], #commission-amount, text=Commission').locator('..').locator('span, strong').last();

    // Success receipt
    this.successBanner      = page.locator('text=Sale Processed Successfully');
    this.receiptSection     = page.locator('#receipt-section, [class*="receipt"]').first();
  }

  // ── ACTIONS 

  async goto() {
    await this.page.goto('https://quality-engineering-labs.vercel.app/payment.html');
    await this.page.waitForLoadState('domcontentloaded');
  }

  /**
   * Returns the commission rate currently displayed in the info bar.
   */
  async getDisplayedCommissionRate() {
    const text = await this.commissionDisplay.innerText();
    return parseFloat(text.replace('%', '').trim());
  }

  async processQuickSale({ phone = '0821234567', productType = 'Airtime', amount = 50 } = {}) {
    await this.customerPhoneInput.fill(phone);
    await this.productSelect.selectOption({ label: productType });
   
    const amountInput = this.page.locator('input[type="range"]').first();
    if (await amountInput.isVisible()) {
      await amountInput.fill(String(amount));
    }
    await this.confirmCheckbox.check();
    await this.processSaleBtn.click();
  }
}

module.exports = { MerchantDashboardPage };
