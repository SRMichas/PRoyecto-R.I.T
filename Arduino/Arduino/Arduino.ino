#include <LiquidCrystal.h>

int conteo = 0;
LiquidCrystal lcd(7,8,9,10,11,12);

void setup()
{
  Serial.begin(9600);
  lcd.begin(16,2);
  lcd.print("Kiubo");
}
void loop()
{
  delay(5000);
  int ny70 = analogRead(A0);
  Serial.println(ny70);
  if(ny70 > 200 && ny70 < 250)
  {
    lcd.print("Es naranja creo");
    conteo++;
  }
  if(ny70 >50 && ny70 < 150)
  {
    lcd.print("Es negro ue");
    conteo++;
  }
  else if(ny70 > 150)
  {
    lcd.print("Es blanco ue");
    conteo++;
  }
  delay(100);
  String x = Serial.readString();
  Serial.print(x);
  lcd.clear();
}
