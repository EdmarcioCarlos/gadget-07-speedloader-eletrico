// =====================================================================
//  07 - SPEEDLOADER ELÉTRICO COMERCIAL · peças 3D (High Capacity 10k BBs)
//  Versão com reservatório RETANGULAR GRANDE (~10.000 BBs)
//  ESTILO TÁTICO FACETADO · cores: corpo, tampas, roda e travas em PRETO ·
//  reservatório, bico e capas dos botões em COYOTE
// =====================================================================
use <../../_BIBLIOTECA-3D/bb_lib.scad>
$fn = 56;

PECA = "corpo_comercial";   // corpo_comercial | tampa_inferior | reservatorio_comercial | tampa_reservatorio_comercial | roda | trava_roda (x2) | trava_motor | bico_m4 | capa_botao (x2)

X = 90; Y = 70; Z = 110; P = 3;
EIXO = [30, 35, 75];         // centro da roda (eixo ao longo de X)
RODA_R = 15; RODA_E = 6.6;   // roda de 8 bolsos
TUBO = [30, 35];             // tubo de saída (vertical, desce da roda até o bico)
TUBO_D = 6.4;                // furo do tubo (BB de 6 mm)
RES_C = [45, 35];            // centro do reservatório (base)
IR_Z = 30;                   // altura do sensor que conta as BBs
CANTOS = [[6, 6], [X - 6, 6], [6, Y - 6], [X - 6, Y - 6]];
RES_PARAF = 38;              // parafusos M3 que prendem o reservatório
RES_F = 67.2;                // reservatório octogonal original: face a face
FENDA = 16;                  // fenda de entrada das BBs, ao longo da borda da roda
LABIO = 2.5;                 // espessura do lábio flexível anti-pinçamento
C = 6;                       // chanfro dos cantos (estilo tático facetado)

// ===================== RESERVATÓRIO COMERCIAL: CAIXA RETANGULAR 10k BBs =====================
// Cálculo: BB 6mm = ~0,113 cm³ cada. 10.000 BBs = ~1.130 cm³ = 1,13 litros
// Com folga de empacotamento (~60%) = ~1,9 litros
// Caixa: 160 x 110 x 110 mm = 1,936 litros (cabe na K1C 220x220)
// Altura total do aparelho: corpo 110mm + reservatório 110mm = 220mm (limite da K1C)

RES_BOX_W = 160;    // largura X (precisa imprimir deitado ou dividir)
RES_BOX_D = 110;    // profundidade Y
RES_BOX_H = 110;    // altura Z
RES_WALL = 4;       // parede 4mm (resistente)
RES_RIB = 8;        // nervuras internas a cada 8mm

// Para imprimir na K1C (220x220): o reservatório 160x110 cabe deitado na mesa
// Se quiser imprimir em pé: dividir em 2 partes (superior/inferior) com encaixe

// ===================== CORPO COMERCIAL (suporta reservatório retangular) =====================
module corpo_comercial() {
    difference() {
        union() {
            intersection() {
                union() {
                    difference() { prisma_oct(X, Y, Z, C); translate([0, 0, -1]) linear_extrude(Z - P + 1) offset(delta = -P) oct2d(X, Y, C); }
                    for (c = CANTOS) translate([c[0], c[1], 0]) pino(20, 8, 2.6);
                    // Parafusos do reservatório retangular: 4 cantos
                    for (sx = [-1, 1], sy = [-1, 1])
                        translate([RES_C[0] + sx * (RES_BOX_W/2 - 15), RES_C[1] + sy * (RES_BOX_D/2 - 15), Z - 12])
                            cylinder(h = 12, d = 9);
                }
                translate([0, 0, -0.01]) prisma_oct(X, Y, Z + 0.02, C);
            }
            translate([20, 22, 58]) cube([50, 26, Z - 58 - 0.01]);
            translate([TUBO[0], TUBO[1], -11]) cylinder(h = 71, d = 14);
            apoio_tela(P, 45, 50, normal = "y");
            translate([X - 0.01, 35, 38]) rotate([0, 90, 0]) difference() { moldura_oct(46, 2); translate([0, 0, -1]) cylinder(h = 4, d = 37); }
            for (xx = [25, 65]) translate([xx, 0.01, 36]) rotate([90, 0, 0]) moldura_oct(15, 2);
            translate([14, Y - 0.01, 8]) rotate([90, 0, 0]) mirror([0, 0, 1]) hex_relevo(62, 26, 1, 4);
        }
        // Entrada das BBs (fenda 16mm alinhada com a roda) + assento do reservatório retangular
        translate([EIXO[0], EIXO[1], EIXO[2]]) cylinder(h = 50, d = 8.4);
        // Rebaixo retangular para o reservatório sentar
        translate([RES_C[0] - RES_BOX_W/2, RES_C[1] - RES_BOX_D/2, Z - 2])
            cube([RES_BOX_W + 0.6, RES_BOX_D + 0.6, 3]);
        // Parafusos: 4 cantos do reservatório
        for (sx = [-1, 1], sy = [-1, 1])
            translate([RES_C[0] + sx * (RES_BOX_W/2 - 15), RES_C[1] + sy * (RES_BOX_D/2 - 15), Z - 10])
                cylinder(h = 11, d = 2.6);
        // Câmara da roda + saída
        translate([EIXO[0] - RODA_E/2 - 0.4, EIXO[1], EIXO[2]]) rotate([0, 90, 0]) cylinder(h = RODA_E + 0.8, r = RODA_R + 0.6);
        translate([EIXO[0] - RODA_E/2 - 0.4, EIXO[1] - RODA_R - 0.6, EIXO[2]]) cube([RODA_E + 0.8, 2*RODA_R + 1.2, 40]);
        translate([TUBO[0], TUBO[1], -12]) cylinder(h = EIXO[2] + 12, d = TUBO_D);
        // Motor N20
        translate([EIXO[0] + RODA_E/2 + 0.4, EIXO[1] - 5.2, EIXO[2] - 6.2]) cube([45, 10.4, 12.4]);
        translate([EIXO[0] + RODA_E/2 + 0.4, EIXO[1] - 5.2, 57]) cube([45, 10.4, EIXO[2] - 6.2 - 57 + 0.01]);
        translate([EIXO[0] - 9, EIXO[1], EIXO[2]]) rotate([0, 90, 0]) cylinder(h = 19, d = 4);
        for (yy = [EIXO[1] - 9.5, EIXO[1] + 9.5]) translate([52, yy, 57]) cylinder(h = 11, d = 2.6);
        // Sensor IR
        translate([TUBO[0], TUBO[1] - 12, IR_Z]) rotate([-90, 0, 0]) cylinder(h = 7.6, d = 5.2);
        translate([TUBO[0], TUBO[1] + 4.4, IR_Z]) rotate([-90, 0, 0]) cylinder(h = 8, d = 5.2);
        translate([TUBO[0], TUBO[1] - 5, IR_Z]) rotate([-90, 0, 0]) cylinder(h = 10, d = 3);
        // Frente: tela OLED + botões
        translate([45 - 11.5, -1, 50 - 3.2]) cube([23, P + 2, 6.4]);
        translate([45 - 14.5, -0.01, 50 - 6.2]) cube([29, 1.2, 12.4]);
        for (xx = [25, 65]) translate([xx, -3, 36]) rotate([-90, 0, 0]) cylinder(h = P + 4, d = 9.6);
        // Lateral direita: gatilho
        translate([X - P - 1, 35, 38]) rotate([0, 90, 0]) cylinder(h = P + 2, d = 30);
        // Lateral esquerda: chave e USB-C
        translate([-1, 35 - 4.25, 22 - 1.8]) cube([P + 2, 8.5, 3.6]);
        translate([-1, 35 - 4.75, 12 - 1.9]) cube([P + 2, 9.5, 3.8]);
    }
}

// ===================== TAMPA INFERIOR =====================
module tampa_inferior() {
    difference() {
        hull() { translate([0, 0, 1]) prisma_oct(X, Y, 2, C); linear_extrude(3) offset(delta = -1) oct2d(X, Y, C); }
        translate([TUBO[0], TUBO[1], 0]) furo(14.4);
        for (c = CANTOS) translate([c[0], c[1], 0]) { furo(3.4); translate([0, 0, -0.01]) cylinder(h = 1.8, d1 = 6.5, d2 = 3.4); }
    }
}

// ===================== RESERVATÓRIO COMERCIAL: CAIXA RETANGULAR 10k BBs =====================
module reservatorio_comercial() {
    BOCA = [EIXO[0] - RES_C[0], EIXO[1] - RES_C[1]];
    // Fundo cônico/funil que direciona BBs para a fenda da roda
    FUNIL_H = 35;    // altura do funil

    difference() {
        union() {
            // Caixa principal (paredes retas)
            translate([-RES_BOX_W/2, -RES_BOX_D/2, FUNIL_H])
                cube([RES_BOX_W, RES_BOX_D, RES_BOX_H - FUNIL_H]);
            // Funil inferior (direciona para a fenda de 16mm)
            hull() {
                translate([-RES_BOX_W/2, -RES_BOX_D/2, 0]) cube([RES_BOX_W, RES_BOX_D, 0.01]);
                translate([BOCA[0] - 3.5, BOCA[1] - FENDA/2, FUNIL_H]) cube([7, FENDA, 0.01]);
            }
            // Fenda de saída (alinhada com a roda)
            translate([BOCA[0] - 3.5, BOCA[1] - FENDA/2, -1]) cube([7, FENDA, FUNIL_H + 2]);
            // Orelhas dos parafusos (4 cantos)
            for (sx = [-1, 1], sy = [-1, 1])
                hull() {
                    translate([sx * (RES_BOX_W/2 - 10), sy * (RES_BOX_D/2 - 10), 1.5]) cylinder(h = 4, d = 12);
                    translate([sx * (RES_BOX_W/2 - 15), sy * (RES_BOX_D/2 - 15), 1.5]) cylinder(h = 4, d = 9);
                }
            // Nervuras internas de reforço (evita empenamento paredes grandes)
            for (x = [-RES_BOX_W/2 + RES_RIB : RES_RIB : RES_BOX_W/2 - RES_RIB])
                translate([x, -RES_BOX_D/2, FUNIL_H]) cube([1.5, RES_BOX_D, RES_BOX_H - FUNIL_H]);
            for (y = [-RES_BOX_D/2 + RES_RIB : RES_RIB : RES_BOX_D/2 - RES_RIB])
                translate([-RES_BOX_W/2, y, FUNIL_H]) cube([RES_BOX_W, 1.5, RES_BOX_H - FUNIL_H]);
        }
        // Furos dos parafusos (passantes + alojamento porca)
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (RES_BOX_W/2 - 15), sy * (RES_BOX_D/2 - 15), 0]) {
                furo(3.4, 10);
                translate([0, 0, 3.9]) cylinder(h = 1.62, d1 = 3.4, d2 = 6.5);
            }
        // MARCA DO PROJETO (única): numa face lateral (160mm de largura)
        translate([RES_BOX_W/2 + 0.6, 0, 50]) rotate([0, -90, 0]) linear_extrude(1) text("BLACK BIRD", size = 8, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        translate([RES_BOX_W/2, 0, 70]) rotate([0, -90, 0]) translate([0, 0, -0.6]) linear_extrude(0.62) emblema2d(1.2);
    }
}

// ===================== TAMPA DO RESERVATÓRIO COMERCIAL (retangular) =====================
module tampa_reservatorio_comercial() {
    difference() {
        union() {
            // Tampa com borda chanfrada (estilo tático)
            hull() {
                translate([-RES_BOX_W/2, -RES_BOX_D/2, 1]) cube([RES_BOX_W + 4, RES_BOX_D + 4, 1]);
                linear_extrude(3) offset(delta = -1)
                    translate([-RES_BOX_W/2 - 1, -RES_BOX_D/2 - 1]) square([RES_BOX_W + 2, RES_BOX_D + 2]);
            }
            // Aba que desce por dentro (vedação)
            translate([-RES_BOX_W/2 + 2, -RES_BOX_D/2 + 2, 0]) cube([RES_BOX_W - 4, RES_BOX_D - 4, 4]);
        }
        // Furo central opcional para futura expansão (tampa garrafa, sensor nível, etc)
        // translate([0, 0, 0]) cylinder(h = 5, d = 20);
        // Nervuras em V no topo (estilo tático)
        for (x = [-RES_BOX_W/2 + 10 : 20 : RES_BOX_W/2 - 10])
            translate([x, -RES_BOX_D/2 - 0.01, 3]) rotate([90, 0, 0]) linear_extrude(1) polygon(points=[[-5,0],[5,0],[0,3]]);
    }
}

// ===================== RODA DE 8 BOLSOS =====================
module roda() {
    difference() {
        cylinder(h = RODA_E, r = RODA_R);
        for (a = [0 : 45 : 359]) rotate([0, 0, a]) translate([RODA_R - 2.6, 0, -1]) cylinder(h = RODA_E + 2, d = 6.6);
        translate([0, 0, -1]) intersection() { cylinder(h = RODA_E + 2, d = 3.1); translate([-2, -1.25 - 0.05, 0]) cube([4, 2.5 + 0.1 + 0.6, RODA_E + 2]); }
    }
}

// ===================== TRAVA DA RODA =====================
module trava_roda() {
    y0 = EIXO[1] - RODA_R - 0.4; y1 = EIXO[1] - FENDA/2;
    difference() {
        translate([EIXO[0] - RODA_E/2 - 0.2, y0, EIXO[2] + 6]) cube([RODA_E + 0.4, y1 - y0, Z - 1.5 - EIXO[2] - 6]);
        translate([EIXO[0] - 10, EIXO[1], EIXO[2]]) rotate([0, 90, 0]) cylinder(h = 20, r = RODA_R + 0.6, $fn = 96);
        translate([EIXO[0] - 10, y1 - LABIO - 0.8, EIXO[2] + 6 - 1]) cube([20, 0.8, 23 - 6 + 1]);
    }
}

// ===================== TRAVA DO MOTOR =====================
module trava_motor() {
    difference() {
        union() {
            translate([34, EIXO[1] - 12, 0]) prisma_oct(35, 24, 3, 2);
            translate([36, EIXO[1] - 4.9, 2.99]) cube([30, 9.8, (EIXO[2] - 6.2 - 58) - 0.4 + 0.01]);
        }
        for (yy = [-9.5, 9.5]) translate([52, EIXO[1] + yy, 0]) { furo(3.4); translate([0, 0, -0.01]) cylinder(h = 1.8, d1 = 6.5, d2 = 3.4); }
    }
}

// ===================== BICO M4 =====================
module bico_m4() {
    difference() {
        union() { octogono(20, 10); translate([0, 0, 9.99]) cylinder(h = 14, d = 8); }
        translate([0, 0, -0.01]) cylinder(h = 8, d = 14.3);
        translate([0, 0, -1]) cylinder(h = 10 + 14 - 2 + 1, d = TUBO_D);
        translate([0, 0, 21.99]) cylinder(h = 2.1, d1 = TUBO_D, d2 = 5.7);
        for (a = [0, 90]) rotate([0, 0, a]) translate([-5, -0.4, 18]) cube([10, 0.8, 7]);
        translate([0, -12, 4]) rotate([-90, 0, 0]) cylinder(h = 8, d = 2.6);
    }
}

// ===================== CAPA BOTÃO =====================
module capa_botao(tampa_esp, tipo) { difference() { moldura_oct(15, 2); translate([0, 0, -0.01]) cylinder(h = 3, d = 9.6); translate([0, 0, tampa_esp - 2.5]) cylinder(h = 3, d = 5.4); } }

// ===================== RENDER POR PEÇA =====================
// Para imprimir reservatório 160x110 na K1C (220x220): deitado na mesa (X=160, Y=110)
// Altura 110mm = OK (limite 250mm)

if (PECA == "corpo_comercial") translate([0, Y, Z]) rotate([180, 0, 0]) corpo_comercial();
if (PECA == "tampa_inferior") tampa_inferior();
if (PECA == "reservatorio_comercial") reservatorio_comercial();
if (PECA == "tampa_reservatorio_comercial") tampa_reservatorio_comercial();
if (PECA == "roda") roda();
if (PECA == "trava_roda") translate([0, -(EIXO[1] - RODA_R - 0.4), EIXO[0] + RODA_E/2 + 0.2]) rotate([0, 90, 0]) translate([0, 0, -EIXO[2] - 6]) trava_roda();
if (PECA == "bico_m4") bico_m4();
if (PECA == "trava_motor") translate([0, 0, 0]) trava_motor();
if (PECA == "capa_botao") capa_botao(9, 0);