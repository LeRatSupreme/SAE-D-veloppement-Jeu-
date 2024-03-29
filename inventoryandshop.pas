unit InventoryAndShop;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils;

// ----- TYPES -----

Type
  Player = Record
    money : Integer;
    inventoryItem : array of String;
    sellPrices: array of Integer;
    xp : Integer;
    lvl : Integer;
    stamina : Integer;
    nom : String;
    prenom : String;
  end;



  Shop = Record
    shopItem : array [1..3] of string;
    prix : array [1..3] of Integer;
  end;

  InventoryArray = array of String;
  ShopArray = array [1..3] of String;
  PrixArray = array [1..3] of Integer;

// ----- FONCTIONS ET PROCEDURES -----
// Procedure d'initalisation du joueur
Procedure InitialisationIS();
//FOnction qui retourne l'argent du joueur
Function GetPlayerMoney():integer;
//Fonction qui retourne l'inventaire du joueur sous forme de tableau
Function GetPlayerInventory():InventoryArray;
//Procedure qui ajoute de l'argent au joueur
Procedure AddPlayerMoney(prix : Integer);
//Procedure qui retire de l'argent au joueur
Procedure RemovePlayerMoney(prix : Integer);
//Fonction qui retourne les objets dans le magasin de pierre sous forme de tableau
Function GetShopItems():ShopArray;
//Fonction qui retourne le tableau de prix des objets
Function GetShopItemsPrice():PrixArray;
//Fonction qui ajout un objet dans l'inventaire du joueur et qui retourne si il as reussi ou non
Function AddInventoryItem(item: String; sellPrices : Integer): Boolean;
//Fonction qui permet de retirer un objet dans l'inventaire du joueur et retourne si il as reussi ou non
Function RemoveInventoryItem(item: String): Boolean;
//Fonction qui permet de retirer l'argent et ajouter l'objet dans l'inventaire et qui retourne si il as reussi ou non
Function OnBuy(item: String; price: Integer):Boolean;
//Fonction qui permet d'ajouter de l'argent et retirer l'objet dans l'inventaire et qui retourne si il as reussi ou non
Function OnSell(item: String; price: Integer):Boolean;
//Fonction qui permet de changer la taille du tableau de l'inventaire  et retourne si il as reussi ou non
Function ResizeInventory(newSize: Integer): Boolean;
//Fonction qui permet d'acher des places dans son inventaire en verifiant les places actuelle et si il est a 15 places la fonction dit que c'est impossible
Function BuySlot():Boolean;
//Fonction qui retourne le nombre d'xp du joueur
Function GetPlayerXp():integer;
//Fonction qui retourne le niveau du joueur
Function GetPlayerLvl():integer;
//Procedure qui permet d'ajouter de l'xp au joueur
Procedure AddPlayerXp(xp : Integer);
//Retourne le taux de fatigue du joueur
Function GetPlayerStamina():integer;
//Procedure qui permet de mettre le taux de fatigue au niveau que l'on souhaite
Procedure SetPlayerStamina(stamina : Integer);
//Fonction qui retourne le tableau du prix des objet que le joueur a dans son inventaire
Function GetItemSellPrice(item: String): Integer;
//Procedure qui permet de mettre le nom du joueur
procedure SetPrenom(prenom : String);
//Procedure qui permet de set le nom de la ferme du joueur
procedure SetNom(nom : String);
//Fonction qui retourne le prenom du joueur
Function GetPlayerName():String;
//Fonction qui retourne le nom de la ferme du joueur
Function GetPlayerFerme():String;
//Procedure qui permer d'ajouter un taux de fatigue au joueur
procedure AddPlayerStamina(stamina : Integer);
procedure RemoveItemGraine(item: String);

implementation
// ---- VARIABLE GLOBAL----
var
  myPlayer: Player;   //Variables qui permet d'utiliser le type Player
  pShop : Shop;       //Variable qui permet d'utiliser le type Shop

// ---- PROCEDURE ET FONCTIONS----

//Initialise la monaie, l'inventaire, l'xp, le niveau et le taux de fatigue du joueur
Procedure InitialisationIS();
var
  i : Integer; // Variable de compteur

// Initialise la monnaie du joueur a 200, initialise tout les items dans le shop, initialise la valeur des items, initialise l'inventaire du joueur
//l'xp, le niveau, le taux de fatigue du joueur
begin
 myPlayer.money := 200;

 myPlayer.xp := 0;

 myPlayer.lvl := 1;

 myPlayer.stamina := 0;

 SetLength(myPlayer.inventoryItem, 5);
 SetLength(myPlayer.sellPrices, 5);
 for i := Low(myPlayer.inventoryItem) to High(myPlayer.inventoryItem) do
 begin
    myPlayer.inventoryItem[i] := 'Slot Vide';
    myPlayer.sellPrices[i] := 0;
 end;

 pShop.shopItem[1] := 'Graine de pannais';
 pShop.prix[1] := 20;
 pShop.shopItem[2] := 'Graine de pomme de terre';
 pShop.prix[2] := 50;
 pShop.shopItem[3] := 'Graine de choux-fleurs';
 pShop.prix[3] := 80;
end;

//Retourne l'xp du joueur
Function GetPlayerXp():integer;
begin
 GetPlayerXp := myPlayer.xp ;
end;

//Retourne le niveau du joueur
Function GetPlayerLvl():integer;
begin
 GetPlayerLvl := myPlayer.lvl ;
end;

//Retourne le niveau de stamina
Function GetPlayerStamina():integer;
begin
 GetPlayerStamina := myPlayer.stamina ;
end;

//Procedure qui change le taux de fatigue du joueurs
Procedure SetPlayerStamina(stamina : Integer);
begin
     myPlayer.stamina := stamina;
end;

//Retourne le nombre d'argent que le joueur possède
Function GetPlayerMoney():integer;
begin
 GetPlayerMoney := myPlayer.money;
end;

//Retourne l'inventaire du joueur sous forme de tableau
Function GetPlayerInventory():InventoryArray;
begin
     GetPlayerInventory := myPlayer.inventoryItem;
end;

//Ajouter de l'argent au joueur
Procedure AddPlayerMoney(prix : Integer);
begin
     myPlayer.money :=  myPlayer.money + prix
end;

//Retire de l'argent au joueur
Procedure RemovePlayerMoney(prix : Integer);
begin
     myPlayer.money := myPlayer.money - prix;
end;

//Ajouter un item au joueur
Function AddInventoryItem(item: String; sellPrices : Integer): Boolean;
var
  i: Integer;         //Variable de compteur
  itemAdded: Boolean;  //Variable pour savoir si l'objet a ete ajouter ou non

// Parcours le tableau jusqu'a qu'un item soit changer par le nom de l'item mis en parametre et met le prix de revente de l'item au meme i que l'inventaire et retourne vrai si reussi
begin
  itemAdded := False;

  // Cherche un emplacement vide et ajoute l'élément
  for i := Low(myPlayer.inventoryItem) to High(myPlayer.inventoryItem) do
  begin
    if (not itemAdded) and (myPlayer.inventoryItem[i] = 'Slot Vide') then
    begin
      myPlayer.inventoryItem[i] := item;
      myPlayer.sellPrices[i] := sellPrices;
      itemAdded := True;
    end;
  end;

  // Retourne si l'élément a été ajouté ou non
  AddInventoryItem := itemAdded;
end;

//Retirer l'item au joueur
Function RemoveInventoryItem(item: String): Boolean;
var
  i: Integer;               //Variable de compteur
  itemRemoved: Boolean;     //variable pour savoir si il as reussi ou non

//Parcours le tableau jusqu'a qu'il trouve le nom de l'item et le renvend au prix indiquer dans le tableau et retourne si il as reussi ou pas
begin
  itemRemoved := False;

  // Cherche l'élément et retire s'il est présent
  for i := Low(myPlayer.inventoryItem) to High(myPlayer.inventoryItem) do
  begin
    if (not itemRemoved) and (myPlayer.inventoryItem[i] = item) then
    begin
      myPlayer.inventoryItem[i] := 'Slot Vide';
      itemRemoved := True;
    end;
  end;

  // Retourne si l'élément a été retiré ou non
  RemoveInventoryItem := itemRemoved;
end;


//Retirer l'item au joueur
procedure RemoveItemGraine(item: String);
var
  i: Integer;               //Variable de compteur
  itemRemoved : Boolean;

//Parcours le tableau jusqu'a qu'il trouve le nom de l'item et le renvend au prix indiquer dans le tableau et retourne si il as reussi ou pas
begin
  itemRemoved := False;

  // Cherche l'élément et retire s'il est présent
  for i := Low(myPlayer.inventoryItem) to High(myPlayer.inventoryItem) do
  begin
    if (not itemRemoved) and (myPlayer.inventoryItem[i] = item) then
    begin
      myPlayer.inventoryItem[i] := 'Slot Vide';
      itemRemoved := True;
    end;
  end;

end;


//Retourne les items du shop sous forme de tableau
Function GetShopItems():ShopArray;
begin
     GetShopItems := pShop.shopItem;
end;

//Retourne le prix de chaque item du shop sous forme de tableau
Function GetShopItemsPrice():PrixArray;
begin
     GetShopItemsPrice := pShop.prix;
end;

//Fonction qui verifie si le joueur peut acheter ou non
Function OnBuy(item: String; price: Integer):Boolean;
var
  succes : Boolean;
begin
  // Vérifie si le joueur a suffisamment d'argent et d'espace dans l'inventaire
  if (myPlayer.money>= price) and AddInventoryItem(item, price-10) then
  begin
    // Retire l'argent du joueur
    RemovePlayerMoney(price);
    succes := True;
  end
  else
    succes := False;

  OnBuy := succes
end;

//Fonction qui verifie si le joueur peut vendre son item
Function OnSell(item: String; price: Integer):Boolean;
var
  success : Boolean;
begin
  success := false;
  if item <> 'Slot Vide' then
    if RemoveInventoryItem(item) then
    begin
      // Ajoute de l'argent au joueur
      AddPlayerMoney(price);
      success := True;
    end;

  OnSell := success;
end;

// Fonction qui permet de changer ta taille de l'inventaire
Function ResizeInventory(newSize: Integer): Boolean;
var
  currentSize: Integer;
  i : Integer;
begin
  currentSize := Length(myPlayer.inventoryItem);

  // Redimensionne le tableau tout en conservant les éléments existants
  SetLength(myPlayer.inventoryItem, newSize);

  // Initialise les nouveaux éléments à 'Slot Vide' s'il y en a
  for i := currentSize to High(myPlayer.inventoryItem) do
    myPlayer.inventoryItem[i] := 'Slot Vide';

  Result := True;
end;

// Fonction qui permet d'acheter un slot d'inventaire dans la boutique
Function BuySlot():Boolean;
Const
  PRICE = 1000;
var
  succes : Boolean;

//Regarde si le joueur a l'argent et verifie son nombre de place et le modifie en consequence
begin
  succes := false;
   if (GetPlayerMoney()>= PRICE) then
      if Length(myPlayer.inventoryItem) = 5 then
         begin
            ResizeInventory(10);
            RemovePlayerMoney(PRICE);
            succes := true;
         end
      else if  Length(myPlayer.inventoryItem) = 10 then
           begin
            ResizeInventory(15);
            RemovePlayerMoney(PRICE);
            succes := true;
           end;

   BuySlot := succes
end;

//Fonction qui permet d'ajouter de l'xp a un joueur
Procedure AddPlayerXp(xp : Integer);
var
  success : Boolean;

//Voir si le niveau est different de 10 au sinon ajouter l'xp et si l'xp est >= a 100 alors on monte de 1 niveau
begin
  if myPlayer.lvl <> 10 then
     if (myPlayer.xp + xp >= 100) then
        begin
             myPlayer.lvl := myPlayer.lvl + 1;
             myPlayer.xp := (myPlayer.xp + xp) - 100;
        end
        else
            myPlayer.xp := myPlayer.xp + xp;

end;

//procedure qui permet d'ajouter de la fatigue au joueur si la fatigue atteint 90 il tombe dans les pommes
procedure AddPlayerStamina(stamina : Integer);
begin
  if myPlayer.stamina + stamina = 90 then
     //Repos()
  else
    myPlayer.stamina := myPlayer.stamina + stamina ;
end;

//Fonction qui permet d'avoir le prix de l'item a la revente
Function GetItemSellPrice(item: String): Integer;
var
  i: Integer;
  found: Boolean;
  prix : Integer;
begin
  found := False;

  // Parcourez les items de l'inventaire pour trouver le prix de vente
  i := Low(myPlayer.inventoryItem);
  while (i <= High(myPlayer.inventoryItem)) and (not found) do
  begin
    if (myPlayer.inventoryItem[i] = item) then
    begin
      // Retourne le prix de vente correspondant à l'item
      prix := myPlayer.sellPrices[i];
      found := True;  // Marque que l'item a été trouvé
    end
    else
      Inc(i);  // Passe à l'élément suivant

  end;

  // Si l'item n'est pas trouvé, retourne 0 (ou une valeur par défaut)
  if not found then
    GetItemSellPrice := 0
  else
      GetItemSellPrice := prix;
end;

// Procedure qui permet de mettre le prenom au joueur
procedure SetPrenom(prenom : String);
begin
   myPlayer.prenom := prenom;
end;

// Procedure qui permet de nomer la ferme
procedure SetNom(nom : String);
begin
   myPlayer.nom := nom;
end;

//Fonction qui retourne le prenom du joueur
Function GetPlayerName():String;
begin
  GetPlayerName := myPlayer.prenom;
end;

//Fonction qui retourne le nom de la ferme au joueur
Function GetPlayerFerme():String;
begin
  GetPlayerFerme := myPlayer.nom;
end;

end.


