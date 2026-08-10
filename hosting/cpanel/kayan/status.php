<?php
/**
 * KAYAN / Rukn El Tatawer — emergency AppControl fallback (cPanel).
 *
 * PRIMARY authority is NestJS AppControl (Admin → PostgreSQL → API).
 * This file is EMERGENCY ONLY when the API is unreachable.
 *
 * Upload this folder to:
 *   public_html/kayan/
 *
 * Planned public URLs (after you upload — NOT assumed live today):
 *   https://www.rukn-eltatawer.com/kayan/status.json
 *   https://www.rukn-eltatawer.com/kayan/status.php
 *
 * BEFORE production upload: change $secret below. Never put this secret in Flutter.
 *
 * Toggle:
 *   status.php?key=YOUR_SECRET&action=off
 *   status.php?key=YOUR_SECRET&action=on
 */
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Access-Control-Allow-Origin: *');

$secret = 'CHANGE_ME_CPANEL_SECRET'; // <<< CHANGE BEFORE UPLOAD
$store  = __DIR__ . '/status.flag';

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
    'enabled'         => $enabled,
    'maintenanceMode' => false,
    'forceUpdate'     => false,
    'messageAr'       => $enabled
        ? 'التطبيق يعمل بشكل طبيعي.'
        : 'تم إيقاف التطبيق من لوحة التحكم (ركن التطور).',
    'messageEn'       => $enabled
        ? 'The app is running normally.'
        : 'The app was disabled from the publisher control panel.',
    'supportUrl'      => 'https://www.rukn-eltatawer.com/',
    'website'         => 'https://www.rukn-eltatawer.com/',
    'websiteUrl'      => 'https://www.rukn-eltatawer.com/',
    'privacyUrl'      => 'https://www.rukn-eltatawer.com/privacy',
    'termsUrl'        => 'https://www.rukn-eltatawer.com/terms',
    'appDownloadUrl'  => 'https://www.rukn-eltatawer.com/kayan/',
    'whatsappUrl'     => '',
    'phoneUrl'        => '',
    'minVersion'      => '1.0.0',
    'latestVersion'   => '1.0.0',
], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
