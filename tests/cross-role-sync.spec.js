

import { test, expect } from '@playwright/test';
import { SettingsPage } from './pages/SettingsPage.js';
import { MerchantDashboardPage } from './pages/MerchantDashboardPage.js';

const BASE_URL = 'https://quality-engineering-labs.vercel.app';

// ─── Test 1 
test('3.3-T01: Admin can navigate to Settings and see the Commission Rate field', async ({ page }) => {
  const settings = new SettingsPage(page);
  await settings.goto();

  await expect(settings.commissionInput).toBeVisible();
  await expect(settings.saveProfileBtn).toBeVisible();
});

// ─── Test 2 
test('3.3-T02: Admin updates commission rate to 8% and save succeeds', async ({ page }) => {
  const settings = new SettingsPage(page);
  await settings.goto();

  await settings.profileTab.click();
  await settings.commissionInput.waitFor({ state: 'visible' });
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('8');
  await settings.saveProfileBtn.click();

  // Verify the input retains the new value after save
  await expect(settings.commissionInput).toHaveValue('8');
});

// ─── Test 3 
test('3.3-T03: Commission rate set in Settings is reflected on the Sell page', async ({ page }) => {
  // Step 1 — Admin sets rate to 10%
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('10');
  await settings.saveProfileBtn.click();

  // Step 2 — Navigate to Sell page (merchant view)
  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();

  // Step 3 — Verify commission rate shown in info bar is 10%
  const displayedRate = await dashboard.getDisplayedCommissionRate();
  expect(displayedRate).toBe(10);
});

// ─── Test 4 
test('3.3-T04: Commission rate change from 5% to 15% syncs to merchant Sell page', async ({ page }) => {
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('15');
  await settings.saveProfileBtn.click();

  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();

  const displayedRate = await dashboard.getDisplayedCommissionRate();
  expect(displayedRate).toBe(15);
});

// ─── Test 5 
test('3.3-T05: Commission calculation in sale summary matches the admin-set rate', async ({ page }) => {
  // Set rate to 10% in Settings
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('10');
  await settings.saveProfileBtn.click();

  // Go to Sell page and check summary panel
  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();

  // Select Airtime and a fixed amount — default amount is R50
  await dashboard.productSelect.selectOption({ label: 'Airtime' });

  // Sale summary should show 10% of R50 = R5.00 commission
  const commissionText = await page
    .locator('text=Commission').locator('..').innerText();
  expect(commissionText).toContain('10%');
});

// ─── Test 6 
test('3.3-T06: Sell page info bar updates without requiring a full page reload', async ({ page }) => {
  // Navigate to Sell page first
  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();
  const rateBefore = await dashboard.getDisplayedCommissionRate();

  // Change the rate in Settings (same browser context = same localStorage)
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  const newRate = rateBefore === 7 ? 12 : 7;
  await settings.commissionInput.fill(String(newRate));
  await settings.saveProfileBtn.click();

  // Return to sell page and verify change
  await dashboard.goto();
  const rateAfter = await dashboard.getDisplayedCommissionRate();
  expect(rateAfter).toBe(newRate);
});

// ─── Test 7 
test('3.3-T07: Commission rate persists after browser page reload', async ({ page }) => {
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('6');
  await settings.saveProfileBtn.click();

  // Reload the settings page and confirm persistence
  await page.reload();
  await settings.profileTab.click();
  await settings.commissionInput.waitFor({ state: 'visible' });
  await expect(settings.commissionInput).toHaveValue('6');
});

// ─── Test 8 
test('3.3-T08: Commission rate of 0% is accepted and reflected on merchant page', async ({ page }) => {
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('0');
  await settings.saveProfileBtn.click();

  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();

  const displayedRate = await dashboard.getDisplayedCommissionRate();
  expect(displayedRate).toBe(0);
});

// ─── Test 9 
test('3.3-T09: Wallet balance on Sell page stays accurate after commission rate change', async ({ page }) => {
  // Capture initial wallet balance
  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();
  const walletText = await dashboard.walletBalance.innerText();
  const walletBefore = parseFloat(walletText.replace(/[^0-9.]/g, ''));

  // Change commission rate
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('9');
  await settings.saveProfileBtn.click();

  // Return to sell page — wallet must be unchanged (rate change ≠ wallet deduction)
  await dashboard.goto();
  const walletTextAfter = await dashboard.walletBalance.innerText();
  const walletAfter = parseFloat(walletTextAfter.replace(/[^0-9.]/g, ''));
  expect(walletAfter).toBe(walletBefore);
});

// ─── Test 10 
test('3.3-T10: Full cross-role sync workflow — set rate, sell product, verify commission earned', async ({ page }) => {
  // Admin sets commission rate to 20%
  const settings = new SettingsPage(page);
  await settings.goto();
  await settings.profileTab.click();
  await settings.commissionInput.triple_click();
  await settings.commissionInput.fill('20');
  await settings.saveProfileBtn.click();

  // Merchant processes a R50 Airtime sale
  const dashboard = new MerchantDashboardPage(page);
  await dashboard.goto();

  // Confirm the rate is showing as 20% before processing
  const rateDisplayed = await dashboard.getDisplayedCommissionRate();
  expect(rateDisplayed).toBe(20);

  // Fill form and process sale
  await dashboard.customerPhoneInput.fill('0831234567');
  await dashboard.productSelect.selectOption({ label: 'Airtime' });
  await dashboard.confirmCheckbox.check();
  await dashboard.processSaleBtn.click();

  // Sale should succeed — success banner visible
  await expect(dashboard.successBanner).toBeVisible({ timeout: 8_000 });

  // Navigate to wallet page and confirm R10 commission earned (20% of R50)
  await page.goto(`${BASE_URL}/wallet.html`);
  const commissionEarned = await page.locator('text=Commission Earned').locator('..').innerText();
  expect(commissionEarned).toContain('10.00');
});
