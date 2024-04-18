import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.LayoutManager;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import java.lang.String;
import java.lang.Exception;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


public class JulianDateConverter {
   static DateTimeFormatter fmtJ = DateTimeFormatter.ofPattern("yyDDD");
   static DateTimeFormatter fmtG = DateTimeFormatter.ofPattern("yyyyMMdd");	
   static String nowG;
   static String nowJ;	
   public static void main(String[] args) {
      createWindow();
      LocalDate now = LocalDate.now();
      nowG  = now.format(fmtG);
      nowJ  = now.format(fmtJ);
      //System.out.println(nowG + " " +  nowJ);
   }

   private static void createWindow() {    
      JFrame frame = new JFrame("Julian Date Converter");
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      createUI(frame);
      frame.setSize(500, 100);      
      frame.setLocationRelativeTo(null);  
      frame.setVisible(true);
   }

   private static void createUI(final JFrame frame){  
      JPanel panel = new JPanel();
      LayoutManager layout = new FlowLayout();  
      panel.setLayout(layout);       

      JButton button = new JButton("Proceed");
      final JLabel label = new JLabel();
      button.addActionListener(new ActionListener() {
         @Override
         public void actionPerformed(ActionEvent e) {
            String result = (String)JOptionPane.showInputDialog(
               frame,
               "Input A Date like " + nowG + " or " + nowJ, 
               "Date Converter",            
               JOptionPane.PLAIN_MESSAGE,
               null,            
               null, 
               nowG
            );
            String outcome;
            String warning = "Invalid Input Date Format !";
            if(result != null && result.length() > 0)
            {
            	if (result.length() == 5)
                 {
            	   try {
                         LocalDate date = LocalDate.parse(result, fmtJ);
                         outcome = date.format(fmtG);
                         nowJ    = outcome;
            	   } catch (Exception E) {
            		     outcome = warning;
            	   }
                 }
                else if ( result.length() == 8)
            	 {
            	   try {
            	         LocalDate date = LocalDate.parse(result, fmtG);
                         outcome = date.format(fmtJ);
                         nowG    = outcome;
            	   } catch (Exception E) {
            		     outcome = warning;
            	   }
            	 }
                else
                 {
            	   outcome = warning;
                 }	
                label.setText("from: " + result + "  to: " + outcome);
            }
            else 
            {
               label.setText("None selected");
            }
         }
      });

      panel.add(button);
      panel.add(label);
      frame.getContentPane().add(panel, BorderLayout.CENTER);    
   }  
} 