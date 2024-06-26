const stage = new Stage({
  backgroundColor: "Green",
});

document.getElementById("svg-container").style.height = "1100%";

const stateLabelGridConfig = {
  grid_location: {
    x: 10,
    y: 10,
  },
  cell_size: {
    x_size: 100,
    y_size: 350,
  },
  grid_dimensions: {
    y_size: instances.length,
    x_size: 1,
  },
};

const stateLabelsGrid = new Grid(stateLabelGridConfig);

// For every instance, place a visualization in the proper grid location
instances.forEach((inst, idx) => {
  //const lb = idx == loopBack ? " (loopback)" : "";
  stateLabelsGrid.add(
    { x: 0, y: idx },
    new TextBox({
      text: `State: ${idx}`,
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
    y_size: 350,
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

  const deck = instance.signature("Deck");
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

  const foundationItems = instance.signature("Foundation").atoms();

  const numberToSuitMap = {
    1: "Heart",
    2: "Spade",
    3: "Club",
    4: "Diamond",
  };

  const numberToColorMap = {
    0: "Blue",
    1: "Red",
  };

  const suitToColorMap = {
    1: "Red",
    2: "Blue",
    3: "Blue",
    4: "Red",
  };

  function numberToSuit(number) {
    return numberToSuitMap[number];
  }

  function numberToColor(number) {
    return numberToColorMap[number];
  }

  function suitToColor(number) {
    return suitToColorMap[number];
  }

  let card_x = 100;
  let card_y = 200;

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
      y_size: 350,
    },
    grid_dimensions: {
      y_size: 1,
      x_size: 1,
    },
  });

  // deck title
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Deck`,
      coords: { x: -250, y: -150 },
      color: "black",
      fontSize: 20,
      fontWeight: "bold",
    })
  );

  // deck unflipped count
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Unflipped: ${deckUnflipped.length} `,
      coords: { x: -245, y: -130 },
      color: "black",
      fontSize: 16,
    })
  );

  // deck flipped count
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Flipped: ${deckFlipped.length} `,
      coords: { x: -245, y: -110 },
      color: "black",
      fontSize: 16,
    })
  );

  // deck current movable
  const movableString = movable.toString();
  const movCardNum = movableString.substring(4, movableString.length);
  const movableCard =
    cardItems[movCardNum] == undefined ? "" : cardItems[movCardNum];
  const movableSuit =
    cardItems[movCardNum] == undefined
      ? ""
      : numberToSuit(cardItems[movCardNum].join(suitField));
  const movableRank =
    cardItems[movCardNum] == undefined
      ? ""
      : cardItems[movCardNum].join(rankField);
  const movableColor =
    cardItems[movCardNum] == undefined
      ? "Black"
      : numberToColor(cardItems[movCardNum].join(colorField));

  // movable title
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `Movable:`,
      coords: { x: -245, y: -90 },
      color: "Black",
      fontSize: 16,
      fontWeight: "bold",
    })
  );

  // movable card id
  // group.add(
  //   { x: 0, y: 0 },
  //   new TextBox({
  //     text: `${movableCard}`,
  //     coords: { x: -245, y: -70 },
  //     color: `${movableColor}`,
  //     fontSize: 16,
  //   })
  // );

  // movable suit
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `${movableSuit}`,
      coords: { x: -245, y: -60 },
      color: `${movableColor}`,
      fontSize: 20,
      fontWeight: "bold",
    })
  );

  // movable rank
  group.add(
    { x: 0, y: 0 },
    new TextBox({
      text: `${movableRank}`,
      coords: { x: -245, y: -30 },
      color: `${movableColor}`,
      fontSize: 20,
      fontWeight: "bold",
    })
  );

  // foundations

  let foundation_x = -130;
  let foundation_y = -150;

  foundationItems.forEach((foundation) => {
    const highestCard = foundation
      .join(inst.field("highest_card"))
      .tuples()
      .map((tup) => tup.atoms().map((at) => at.id()))
      .flat();
    const foundSuit = foundation
      .join(inst.field("found_suit"))
      .tuples()
      .map((tup) => tup.atoms().map((at) => at.id()))
      .flat();
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: ` ${foundation} `,
        coords: { x: foundation_x, y: foundation_y },
        color: `Black`,
        fontSize: 16,
        fontWeight: "bold",
      })
    );

    const foundationSuit = foundSuit.toString();
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `${numberToSuit(foundSuit)} `,
        coords: { x: foundation_x, y: foundation_y + 30 },
        color: `${suitToColor(foundSuit)}`,
        fontSize: 20,
        fontWeight: "bold",
      })
    );

    const found_display = highestCard == 0 ? "" : highestCard;

    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `${found_display} `,
        coords: { x: foundation_x, y: foundation_y + 60 },
        color: `${suitToColor(foundSuit)}`,
        fontSize: 20,
        fontWeight: "bold",
      })
    );

    if (foundation_x + 50 > 700) {
      foundation_x = 100;
      foundation_y += 100;
    } else {
      foundation_x += 123;
    }
  });

  // piles
  let pile_x = -240;
  let pile_y = 20;

  for (let i = pileItems.length - 1; i >= 0; i--) {
    pile = pileItems[i];

    const pileFlipped = pile
      .join(inst.field("pile_flipped"))
      .tuples()
      .map((tup) => tup.atoms().map((at) => at.id()))
      .flat();

    const pileUnflipped = pile
      .join(inst.field("pile_unflipped"))
      .tuples()
      .map((tup) => tup.atoms().map((at) => at.id()))
      .flat();

    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: ` ${pile} `,
        coords: { x: pile_x, y: pile_y },
        color: `Black`,
        fontSize: 16,
        fontWeight: "bold",
      })
    );

    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `Unflipped: ${pileUnflipped} `,
        coords: { x: pile_x, y: pile_y + 20 },
        color: `Black`,
        fontSize: 16,
      })
    );
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `Flipped: ${pileFlipped.length} `,
        coords: { x: pile_x, y: pile_y + 40 },
        color: `Black`,
        fontSize: 16,
      })
    );

    const topCard = pile
      .join(inst.field("top_card"))
      .tuples()
      .map((tup) => tup.atoms().map((at) => at.id()))
      .flat();
    // pile top card
    const topCardStr = topCard.toString();

    const topCardNum = topCardStr.substring(4, topCardStr.length);
    const topCardID =
      cardItems[topCardNum] == undefined ? topCardNum : cardItems[topCardNum];

    const topCardSuit =
      cardItems[topCardNum] == undefined
        ? ""
        : numberToSuit(cardItems[topCardNum].join(suitField));
    const topCardRank =
      cardItems[topCardNum] == undefined
        ? ""
        : cardItems[topCardNum].join(rankField);
    const topCardColor =
      cardItems[topCardNum] == undefined
        ? "Black"
        : numberToColor(cardItems[topCardNum].join(colorField));

    // top card title
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `Top Card:`,
        coords: { x: pile_x, y: pile_y + 60 },
        color: "Black",
        fontSize: 16,
        fontWeight: "bold",
      })
    );

    // top card card id
    // group.add(
    //   { x: 0, y: 0 },
    //   new TextBox({
    //     text: `${topCardID}`,
    //     coords: { x: pile_x, y: pile_y + 80 },
    //     color: `${topCardColor}`,
    //     fontSize: 16,
    //   })
    // );

    // top card suit
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `${topCardSuit}`,
        coords: { x: pile_x, y: pile_y + 90 },
        color: `${topCardColor}`,
        fontSize: 20,
        fontWeight: "bold",
      })
    );

    // top card rank
    group.add(
      { x: 0, y: 0 },
      new TextBox({
        text: `${topCardRank}`,
        coords: { x: pile_x, y: pile_y + 120 },
        color: `${topCardColor}`,
        fontSize: 20,
        fontWeight: "bold",
      })
    );

    if (pile_x + 50 > 700) {
      pile_x = 100;
      pile_y += 100;
    } else {
      pile_x += 150;
    }
  }

  return group;
}

stage.add(stateGrid);

stage.add(stateLabelsGrid);
// Render the stage
stage.render(svg, document);
