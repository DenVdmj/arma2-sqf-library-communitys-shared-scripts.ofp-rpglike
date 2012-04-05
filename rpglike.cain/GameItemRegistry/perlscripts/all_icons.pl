my @list = qw(
\\DTAEXT\\equip\\m\\m_9k32launcher.paa
\\DTAEXT\\equip\\m\\m_aalauncher.paa
\\DTAEXT\\equip\\m\\m_ak47.paa
\\DTAEXT\\equip\\m\\m_ak74.paa
\\DTAEXT\\equip\\m\\m_aksu.paa
\\DTAEXT\\equip\\m\\m_apmine.paa
\\DTAEXT\\equip\\m\\m_at4Launcher.paa
\\DTAEXT\\equip\\m\\m_carlgustavlauncher.paa
\\DTAEXT\\equip\\m\\m_flare.paa
\\DTAEXT\\equip\\m\\m_flaregreen.paa
\\DTAEXT\\equip\\m\\m_flarered.paa
\\DTAEXT\\equip\\m\\m_flareyellow.paa
\\DTAEXT\\equip\\m\\m_grenadelauncher.paa
\\DTAEXT\\equip\\m\\m_handgrenade.paa
\\DTAEXT\\equip\\m\\m_hk.paa
\\DTAEXT\\equip\\m\\m_lawlauncher.paa
\\DTAEXT\\equip\\m\\m_m4.paa
\\DTAEXT\\equip\\m\\m_m16.paa
\\DTAEXT\\equip\\m\\m_m21.paa
\\DTAEXT\\equip\\m\\m_m60.paa
\\DTAEXT\\equip\\m\\m_mine.paa
\\DTAEXT\\equip\\m\\m_mortar.paa
\\DTAEXT\\equip\\m\\m_pipebomb.paa
\\DTAEXT\\equip\\m\\m_pk.paa
\\DTAEXT\\equip\\m\\m_rpglauncher.paa
\\DTAEXT\\equip\\m\\m_smokeshell.paa
\\DTAEXT\\equip\\m\\m_smokeshellred.paa
\\DTAEXT\\equip\\m\\m_svddragunov.paa
\\DTAEXT\\equip\\m\\m_timebomb.paa
\\DTAEXT\\equip\\w\\w_9k32launcher.paa
\\DTAEXT\\equip\\w\\w_aalauncher.paa
\\DTAEXT\\equip\\w\\w_ak47.paa
\\DTAEXT\\equip\\w\\w_ak47cz.paa
\\DTAEXT\\equip\\w\\w_ak47grenadelauncher.paa
\\DTAEXT\\equip\\w\\w_ak74.paa
\\DTAEXT\\equip\\w\\w_ak74g.paa
\\DTAEXT\\equip\\w\\w_ak74grenadelauncher.paa
\\DTAEXT\\equip\\w\\w_ak74su.paa
\\DTAEXT\\equip\\w\\w_at4launcher.paa
\\DTAEXT\\equip\\w\\w_binocular.paa
\\DTAEXT\\equip\\w\\w_carlgustavlauncher.paa
\\DTAEXT\\equip\\w\\w_hk.paa
\\DTAEXT\\equip\\w\\w_law.paa
\\DTAEXT\\equip\\w\\w_lawlauncher.paa
\\DTAEXT\\equip\\w\\w_m4.paa
\\DTAEXT\\equip\\w\\w_m16.paa
\\DTAEXT\\equip\\w\\w_m16grenadelauncher.paa
\\DTAEXT\\equip\\w\\w_m21.paa
\\DTAEXT\\equip\\w\\w_m60.paa
\\DTAEXT\\equip\\w\\w_mortar.paa
\\DTAEXT\\equip\\w\\w_nvgoggles.paa
\\DTAEXT\\equip\\w\\w_pk.paa
\\DTAEXT\\equip\\w\\w_rpg.paa
\\DTAEXT\\equip\\w\\w_rpglauncher.paa
\\DTAEXT\\equip\\w\\w_svddragunov.paa
ia10.paa
iabrams.paa
ian_doorglass.paa
iaston.paa
ibmp.paa
ibmp_abu.paa
icessna.paa
icivil.paa
icobra.paa
icrew.paa
idelo.paa
igrenadier.paa
ihrl.paa
ijeep.paa
ijeepmg.paa
ijeepmutt.paa
im60.paa
im113.paa
im113_ambu.paa
imedic.paa
imi17.paa
imi24.paa
iminer.paa
imortar.paa
inewport.paa
inri.paa
ipbr.paa
ipilot.paa
iracek.paa
irapid.paa
isaa.paa
isaboteur.paa
isat.paa
iscud.paa
iskoda.paa
islaw.paa
ismg.paa
isniper.paa
it55.paa
it72.paa
it80.paa
itraktor.paa
itruck5t.paa
itruck5tfuel.paa
itruck5trepair.paa
iuaz.paa
iuh60.paa
iural.paa
iuralfuel.paa
iuralrepair.paa
iv3s.paa
iv3sfuel.paa
iv3srepair.paa
ivojak.paa
izsu.paa
);


%weaps = ((
    "6g30" => "\\6g30\\6g30.paa",
    "m16s" => "Dta\\DTAEXT\\equip\\m\\m_m16.paa",
    "kozlice" => "\\kozl\\w_kozlice.paa",
    "g36a" => "\\g36a\\w_g36.paa",
    "mm1" => "\\mm-1mm-1.paa",
    "steyr" => "\\steyr\\w_steyr.paa",
    "xms" => "\\xms\\w_xms.paa",
    "glocks" => "\\O_wp\\w_glocksilent.paa",
    "ingram" => "\\O_wp\\w_ingram.paa",
    "huntingrifle" => "\\O_wp\\w_remigton.paa",
    "revolver" => "\\O_wp\\w_sam.paa",
    "bizon", "\\bizon\\w_bizon.paa",
),
map { /(^.*?\\w_([\w_]+)\.paa$)/; $2, $1 } grep { /\\w_([\w_]+)\.paa$/ } @list
);


%mags = ((
    "bizonmag", "\\bizon\\m_bizon.paa",
    "6g30" => "\\6g30\\m_6g30.paa",
    "g36amag" => "\\g36a\\m_g36.paa",
    "kozliceshell" => "\\kozl\\m_kozlice1.paa",
    "kozliceball" => "\\kozl\\m_kozlice2.paa",
    "mm1magazine" => "\\mm-1\\m_mm1.paa",
    "steyrmag" => "\\steyr\\m_steyr.paa",
    "glocksmag" => "\\O\\Guns\\zasobnik.paa",
    "ingrammag" => "\O\Guns\m_uzi.paa",
    "huntingriflemag" => "m21",
    "revolvermag" => "\\O_wp\\m_revolever.paa",

),
map { /(^.*?\\m_([\w_]+)\.paa$)/; $2, $1 } grep { /\\m_([\w_]+)\.paa$/ } @list
);

%vehs = ((
    "apac" => "\\apac\\iah64.paa",
    "brmd" => "\\brmd\\ibrmd.paa",
    "ch47" => "\\ch47\\ich47.paa",
    "hammer" => "\\humr\\ihmmwv.paa",
    "kolo" => "\\KOLO\\ikolo.paa",
    "Bradley" => "\\m2a2\\im2a2.paa",
    "mini" => "\\MINI\\imini.paa",
    "oh58" => "\\oh58\\ikiowa.paa",
    "su25" => "\\su25\\isu25.paa",
    "trab" => "\\trab\\itrabant.paa",
    "vulcan" => "\\vulcan\\ivulcan.paa",
),
(map { /(^i([\w_]+)\.paa$)/; $2, $1 } grep { /^i.+?\.paa$/ } @list)
);

#print join("\n", map { $_ . ' => "' . %weaps->{$_} . '"' } sort keys %weaps);
print join("\n", map { $_ . ' => "' . %mags->{$_} . '"' } sort keys %mags);
