#!/bin/bash

PANEL="/var/www/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx"

install_welcome() {

echo "Installing Welcome Dashboard..."

cp $PANEL ${PANEL}.backup

sed -i "/PageContentBlock/a\\
{/* DANZXN WELCOME */}\\
<div style={{marginBottom:'20px'}}>\\
<h2>Welcome 👋</h2>\\
<p id='greetingText'></p>\\
<p id='clockText'></p>\\
</div>
" $PANEL

cat << 'EOF' >> $PANEL

// DANZXN WELCOME SCRIPT
setInterval(() => {
const now = new Date();
const hour = now.getHours();
const minute = now.getMinutes();

let greeting = "";

if (hour >= 5 && hour < 12) greeting = "🌅 Selamat Pagi";
else if (hour >= 12 && hour < 15) greeting = "☀️ Selamat Siang";
else if (hour >= 15 && hour < 18) greeting = "🌇 Selamat Sore";
else greeting = "🌙 Selamat Malam";

const greet = document.getElementById("greetingText");
const clock = document.getElementById("clockText");

if (greet) greet.innerText = greeting;
if (clock) clock.innerText =
hour + ":" + (minute < 10 ? "0"+minute : minute) + " WIB";

},1000);
// END DANZXN SCRIPT

EOF

cd /var/www/pterodactyl

echo "Building panel..."
yarn build:production

php artisan view:clear
php artisan cache:clear

echo "Install selesai!"
}

uninstall_welcome() {

echo "Uninstall Welcome..."

if [ -f "${PANEL}.backup" ]; then
cp ${PANEL}.backup $PANEL
echo "Restore backup berhasil"
else
echo "Backup tidak ditemukan"
fi

cd /var/www/pterodactyl

yarn build:production

php artisan view:clear
php artisan cache:clear

echo "Uninstall selesai!"
}

clear
echo "================================="
echo " DANZXN WELCOME INSTALLER"
echo "================================="
echo "1. Install Welcome Dashboard"
echo "2. Uninstall Welcome Dashboard"
echo "3. Exit"
echo "================================="

read -p "Pilih opsi: " pilihan

case $pilihan in
1) install_welcome ;;
2) uninstall_welcome ;;
3) exit ;;
*) echo "Pilihan tidak valid" ;;
esac
