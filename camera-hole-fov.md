Det är en mycket bra och viktig observation. Eftersom linsen har ett synfält (Field of View / FOV) bildar synfältet en kon ut från kameran. Om träväggen/bottenplattan har lite tjocklek (t.ex. $6 - 12\text{ mm}$) riskerar kanterna på hålet att skugga bildens hörn om hålet görs för trångt eller rakt.

---

### 1. Storleken på hålet (Beroende på linstyp)

* **Standardkamera (ca $60^\circ - 75^\circ$ FOV):**
* Om linsen ligger **helt intill insidan** av bottenplattan (trätjocklek $\approx 8 - 10\text{ mm}$) räcker ett rakt borrat hål på **$\varnothing 15 - 18\text{ mm}$**.


* **Vidvinkelkamera / Fisheye ($120^\circ - 160^\circ$ FOV):**
* Vidvinkellinser ser mycket längre ut åt sidorna. Om du har en vidvinkelmodul behöver hålet vara minst **$\varnothing 22 - 25\text{ mm}$** för att undvika svarta hörn (vinjettering).



---

### 2. Två knep för att förhindra att träväggen är i vägen

#### Knep A: Fasa/fasada kanten (Rekommenderas!)

Borra först ett hål som matchar linsens diameter (t.ex. $12\text{ mm}$). Använd sedan en **försänkare (countersink bit)** eller en större borrspets från utsidan/undersidan för att skapa en **$45^\circ$ vinkel (fasning)** på träkanten.

```
  INNE I LÅDAN (Kamera)
  ──────┐       ┌──────
        │   O   │  ◄── Lins ($8-10\text{ mm}$)
  ──────┘       └──────
         \     /   ◄── Fasning ($45^\circ$ konisk utskärning)
  ────────┐   ┌────────
  UTSIGT MOT BRÄDET

```

Detta gör att linsen får fri sikt utåt i hela sin synvinkel samtidigt som hålet på insidan förblir litet och lätt att montera kameran mot.

#### Knep B: Montera linsen nedsänkt i träplattan

Istället för att låta kamerakretskortet sitta helt bakom trät, fräser eller borrar du ett fördjupat spår (blindhål) från insidan så att linsen sticker ner halvvägs i träväggen. Då minskar den effektiva trätjockleken framför linsen till bara $1 - 2\text{ mm}$.

---

### Rekommenderad dimension för din låda

Om du använder en standard Raspberry Pi-kamera eller USB-webbkamera och fasar kanten på undersidan:

1. Borra ett genomgående hål på **$15\text{ mm}$**.
2. Fasa av kanten på undersidan med $45^\circ$ vinkel.
3. Montera kamerakretskortet på insidan med avstånddistanser så att linsen ligger helt jäms med hålets start.
