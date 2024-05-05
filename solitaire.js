const stage = new Stage();

document.getElementById("svg-container").style.height = "1100%";

const stateLabelGridConfig = {
  grid_location: {
    x: 10,
    y: 10,
  },
  cell_size: {
    x_size: 100,
    y_size: 300,
  },
  grid_dimensions: {
    y_size: instances.length,
    x_size: 1,
  },
};

const stateLabelsGrid = new Grid(stateLabelGridConfig);

// For every instance, place a visualization in the proper grid location
instances.forEach((inst, idx) => {
  const lb = idx == loopBack ? " (loopback)" : "";
  stateLabelsGrid.add(
    { x: 0, y: idx },
    new TextBox({
      text: `State:${idx}${lb}`,
      coords: { x: 0, y: 0 },
      color: "black",
      fontSize: 16,
    })
  );
});

const stateGridConfig = {
  grid_location: {
    x: 110,
    y: 10,
  },
  cell_size: {
    x_size: 600,
    y_size: 300,
  },
  grid_dimensions: {
    y_size: instances.length,
    x_size: 1,
  },
};

const stateGrid = new Grid(stateGridConfig);

// For every instance, place a visualization in the proper grid location
instances.forEach((inst, idx) => {
  const lb = idx == loopBack ? " (loopback)" : "";
  stateGrid.add({ x: 0, y: idx }, visualizeState(inst, idx), true);
});

function visualizeState(inst, idx) {
  const cardItems = instance.signature("Card").atoms();
  const suitField = instance.field("suit");
  const rankField = instance.field("rank");
  const colorField = instance.field("color");

  const pileItems = instance.signature("Pile").atoms();
  let pileFlipped = instance.field("pile_flipped");
  let pileUnflipped = instance.field("pile_unflipped");

  const deck = instance.signature("Deck");
  //let movable = instance.field("movable");
  const deckUnflipped = inst
    .signature("Deck")
    .join(inst.field("unflipped"))
    .tuples()
    .map((tup) => tup.atoms().map((at) => at.id()))
    .flat();
  const deckFlipped = inst
    .signature("Deck")
    .join(inst.field("flipped"))
    .tuples()
    .map((tup) => tup.atoms().map((at) => at.id()))
    .flat();
  const movable = inst
    .signature("Deck")
    .join(inst.field("movable"))
    .tuples()
    .map((tup) => tup.atoms().map((at) => at.id()))
    .flat();

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

  // create the space to contain all info for a given state
  const group = new Grid({
    grid_location: {
      x: 0,
      y: 0,
    },
    cell_size: {
      x_size: 600,
      y_size: 300,
    },
    grid_dimensions: {
      y_size: 1,
      x_size: 1,
    },
  });

  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Deck`,
      coords: { x: -240, y: -130 },
      color: "black",
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 20,
    })
  );

  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Unflipped: ${deckUnflipped.length} `,
      coords: { x: -240, y: -110 },
      color: "black",
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 16,
    })
  );

  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Flipped: ${deckFlipped.length} `,
      coords: { x: -240, y: -90 },
      color: "black",
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 16,
    })
  );

  let text = "";
  cardItems.forEach((card) => {
    //text = movable
    text = movable === card.id() ? "L" : "";
  });

  group.add(
    { x: 0, y: 0 },

    new TextBox({
      // text: `Movable: ${cardItems[0].join(rankField)} `,
      text: `Movable: ${text} `,

      coords: { x: -230, y: -70 },
      color: "black",
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 16,
    })
  );
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Flipped: ${deckFlipped.length} `,
      coords: { x: -240, y: -90 },
      color: "black",
      border: { width: 10, color: "red" }, // Specify the border width and color

      fontSize: 16,
    })
  );

  cardItems.forEach((card) => {
    //textContent += `${card.join(suitField)} `;
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: ` ${card} `,
        coords: { x: card_x, y: card_y },
        color: `${numberToColor(card.join(colorField))}`,
        border: { width: 10, color: "red" }, // Specify the border width and color

        fontSize: 16,
      })
    );
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `${numberToSuit(card.join(suitField))} `,
        coords: { x: card_x, y: card_y + 20 },
        color: `${numberToColor(card.join(colorField))}`,
        border: { width: 10, color: "#FFFFFF" }, // Specify the border width and color
        fontSize: 16,
      })
    );
    group.add(
      { x: 0, y: 0 },
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

  // for (let i = pileItems.length - 1; i >= 0; i--) {
  //   const pile = pileItems[i];

  //   stage.add(
  //     new TextBox({
  //       text: ` ${pile} `,
  //       coords: { x: pile_x, y: pile_y },
  //       color: `black`,
  //       fontSize: 16,
  //     })
  //   );

  //   stage.add(
  //     new TextBox({
  //       text: `Flipped: ${pile.join(pileFlipped)} `,
  //       coords: { x: pile_x, y: pile_y + 20 },
  //       color: `black`,
  //       fontSize: 16,
  //     })
  //   );

  //   stage.add(
  //     new TextBox({
  //       text: ` # Unflipped: ${pile.join(pileUnflipped)} `,
  //       coords: { x: pile_x, y: pile_y + 40 },
  //       color: `black`,
  //       fontSize: 16,
  //     })
  //   );

  //   pile_x += 150;
  // };
  return group;
}

stage.add(stateGrid);

stage.add(stateLabelsGrid);
// Render the stage
stage.render(svg, document);
