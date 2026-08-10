<?php
/**
 * KAYAN remote kill-switch for cPanel.
 *
 * Upload this folder to:
 *   public_html/kayan/
 * so the app can read:
 *   https://www.rukn-eltatawer.com/kayan/status.php
 *   (or status.json)
 *
 * To DISABLE the app for all installs:
 *   - Set "enabled" => false below, OR
 *   - Delete this file / status.json from cPanel
 *
 * Optional: protect edits with a secret query:
 *   status.php?key=YOUR_SECRET&action=off
 *   status.php?key=YOUR_SECRET&action=on
 */
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Access-Control-Allow-Origin: *');

$secret = 'CHANGE_ME_CPANEL_SECRET'; // change this
$store  = __DIR__ . '/status.flag';

// Toggle via secret URL (optional)
$key = $_GET['key'] ?? '';
$action = $_GET['action'] ?? '';
if ($key !== '' && hash_equals($secret, $key)) {
    if ($action === 'off') {
        file_put_contents($store, '0');
    } elseif ($action === 'on') {
        file_put_contents($store, '1');
    }
}

$enabled = true;
if (is_file($store)) {
    $enabled = trim((string) file_get_contents($store)) !== '0';
}

echo json_encode([
    'enabled'    => $enabled,
    'messageAr'  => $enabled
        ? 'التطبيق يعمل بشكل طبيعي.'
        : 'تم إيقاف التطبيق من لوحة التحكم (ركن التطور).',
    'messageEn'  => $enabled
        ? 'The app is running normally.'
        : 'The app was disabled from the publisher control panel.',
    'supportUrl' => 'https://www.rukn-eltatawer.com/',
    'website'    => 'https://www.rukn-eltatawer.com/',
    'minVersion' => '1.0.0',
], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
