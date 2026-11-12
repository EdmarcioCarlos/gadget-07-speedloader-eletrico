// 07 - SPEEDLOADER COMERCIAL · MONTAGEM (só para os desenhos da prévia; não é para imprimir)
use <pecas_comercial.scad>
use <../../_BIBLIOTECA-3D/bb_lib.scad>
$fn = 56;

EXTRAS = true;           // false = só as peças impressas (usado para as cotas)
CORTE = false;           // true = corta ao meio (y < 55) para ver a roda, as travas e o tubo

// Dimensões do corpo comercial (iguais ao padrão)
X = 90; Y = 70; Z = 110;
EIXO = [30, 35, 75]; RODA_E = 6.6;
TUBO = [30, 35]; RES_C = [45, 35];
RES_BOX_W = 160; RES_BOX_D = 110; RES_BOX_H = 110;
FUNIL_H = 35;
FENDA = 16;
C = 6;  // chanfro

module tudo() {
    // Corpo comercial (preto)
    color(cor_preto()) corpo_comercial();

    // Mecanismo (igual ao padrão)
    color(cor_preto()) translate([EIXO[0] - RODA_E/2, EIXO[1], EIXO[2]]) rotate([0, 90, 0]) roda();
    color(cor_preto()) trava_roda();
    color(cor_preto()) translate([0, 2 * EIXO[1], 0]) mirror([0, 1, 0]) trava_roda();
    color(cor_preto()) translate([0, 0, 55]) trava_motor();

    if (EXTRAS) {                                                                       // componentes (referência)
        color("#9aa4aa") translate([33.8, 29.9, 68.9]) cube([34, 10.2, 12.2]);              // motor N20
        for (k = [0:4]) color("#f2efe6") translate([30, 35, 52 - k * 6.1]) sphere(d = 6);    // BBs no tubo
        color("#c9a227") translate([5, 4, 3]) cube([77, 21, 20]);                           // suporte 18650 (deitado no fundo)
        color("#202020") translate([45, 27, 4]) cube([22.5, 18, 1.6]);                      // ESP32-C3
        color("#2b6a8f") translate([62, 46, 4]) cube([24, 16, 1.6]);                        // L9110S + LM393
        color("#7a1f1f") translate([5, 46, 4]) cube([28, 17, 1.6]);                         // carregador 18650 / 5 V
    }

    // Tampa inferior (preto)
    color(cor_preto()) translate([0, 0, -3]) tampa_inferior();

    // Reservatório COMERCIAL (coyote) - posicionado sobre o corpo
    // O reservatório tem altura RES_BOX_H, com funil de FUNIL_H
    // Base do reservatório fica em Z (topo do corpo)
    color(cor_coyote()) translate([RES_C[0], RES_C[1], Z - 1.5]) reservatorio_comercial();

    // Tampa do reservatório comercial (preto) - fica no topo do reservatório
    // Altura total do reservatório = RES_BOX_H, então tampa fica em Z + RES_BOX_H
    color(cor_preto()) translate([RES_C[0], RES_C[1], Z - 1.5 + RES_BOX_H + 3]) rotate([180, 0, 0]) tampa_reservatorio_comercial();

    // Bico M4 (coyote)
    color(cor_coyote()) translate([TUBO[0], TUBO[1], -3]) rotate([180, 0, 0]) bico_m4();

    if (EXTRAS) for (xx = [25, 65]) color(cor_coyote()) translate([xx, -1.5, 36]) rotate([90, 0, 0]) cylinder(h = 3, d = 9);   // capas - e +
    if (EXTRAS) color("#b3261e") translate([X + 2, 35, 38]) rotate([0, 90, 0]) cylinder(h = 6, d = 24);                        // gatilho (arcade)
    if (EXTRAS) color("#0b0f14") translate([45 - 11.5, -0.4, 50 - 3.2]) cube([23, 0.5, 6.4]);                                  // tela
}

// Vista padrão (sem corte)
if (!CORTE) tudo();

// Vista de corte (metade esquerda, y < 35)
if (CORTE) intersection() { tudo(); translate([-20, -10, -60]) cube([140, 55 + 10, 400]); }