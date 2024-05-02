const stage = new Stage();
const cardItems = instance.signature("Card").atoms();
const suitField = instance.field("suit");
const rankField = instance.field("rank");
const colorField = instance.field("color");

const pileItems = instance.signature("Pile").atoms();
let pileFlipped = instance.field("pile_flipped");

let textContent = "";

const numberToSuitMap = {
  1: "Heart",
  2: "Spade",
  3: "Club",
  4: "Diamond",
};

const numberToColorMap = {
  0: "Black",
  1: "Red",
};

function numberToSuit(number) {
  return numberToSuitMap[number];
}

function numberToColor(number) {
  return numberToColorMap[number];
}

let card_x = 100;
let card_y = 200;

let pile_x = 100;
let pile_y = 100;

const cardWidth = 50;
const cardHeight = 70;

// Loop through all cards and concatenate their suit field values
cardItems.forEach((card) => {
  //textContent += `${card.join(suitField)} `;
  stage.add(
    new TextBox({
      text: ` ${card} `,
      coords: { x: card_x, y: card_y },
      color: `${numberToColor(card.join(colorField))}`,
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 16,
    })
  );
  stage.add(
    new TextBox({
      text: `${numberToSuit(card.join(suitField))} `,
      coords: { x: card_x, y: card_y + 20 },
      color: `${numberToColor(card.join(colorField))}`,
      border: { width: 10, color: "#FFFFFF" }, // Specify the border width and color
      fontSize: 16,
    })
  );
  stage.add(
    new TextBox({
      text: `${card.join(rankField)} `,
      coords: { x: card_x, y: card_y + 40 },
      color: `${numberToColor(card.join(colorField))}`,
      fontSize: 16,
    })
  );
  //
  if (card_x + 50 > 700) {
    card_x = 100;
    card_y += 100;
  } else {
    card_x += 75;
  }
});

pileItems.forEach((pile) => {
  stage.add(
    new TextBox({
      text: ` ${pile} `,
      coords: { x: pile_x, y: pile_y },
      color: `black`,
      fontSize: 16,
    })
  );

  stage.add(
    new TextBox({
      text: ` ${pile.join(pileFlipped)} `,
      coords: { x: pile_x, y: pile_y + 20 },
      color: `black`,
      fontSize: 16,
    })
  );

  pile_x += 150;
});

// // Render the stage
stage.render(svg, document);
