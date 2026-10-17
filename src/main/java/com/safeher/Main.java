package com.safeher;

import com.safeher.model.*;
import com.safeher.service.*;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.sql.SQLException;
import java.util.List;

public class Main {
    public static void main(String[] args){SwingUtilities.invokeLater(()->new SafeHerFrame().setVisible(true));}
}

class SafeHerFrame extends JFrame {
    private final AuthService auth=new AuthService();
    SafeHerFrame(){setTitle("SafeHer | Safety companion prototype");setDefaultCloseOperation(EXIT_ON_CLOSE);setSize(880,600);setLocationRelativeTo(null);setContentPane(new LoginPanel(this));}
    void showDashboard(User user){setContentPane(new DashboardPanel(this,user));revalidate();repaint();}
    void showLogin(){setContentPane(new LoginPanel(this));revalidate();repaint();}
    void login(String email,char[] password){try{User u=auth.login(email,new String(password));if(u==null)throw new IllegalArgumentException("Email or password is incorrect.");showDashboard(u);}catch(Exception e){error(e);}finally{java.util.Arrays.fill(password,'\0');}}
    void register(String name,String email,String phone,char[] password){try{User u=auth.register(name,email,phone,new String(password));showDashboard(u);JOptionPane.showMessageDialog(this,"Account created. Welcome, "+u.fullName()+"!");}catch(Exception e){error(e);}finally{java.util.Arrays.fill(password,'\0');}}
    static void error(Exception e){
        String msg=e.getMessage();
        if(e instanceof SQLException sql){
            msg="Database error (SQLState "+sql.getSQLState()+", code "+sql.getErrorCode()+"): "+sql.getMessage();
            System.err.println(msg);
        }
        JOptionPane.showMessageDialog(null,msg==null?"The operation could not be completed.":msg,"SafeHer",JOptionPane.ERROR_MESSAGE);
    }
    static JPanel form(){JPanel p=new JPanel(new GridBagLayout());p.setBorder(new EmptyBorder(28,45,28,45));return p;}
    static void row(JPanel p,int y,String label,JComponent c){GridBagConstraints g=new GridBagConstraints();g.insets=new Insets(6,6,6,6);g.gridx=0;g.gridy=y;g.anchor=GridBagConstraints.LINE_END;p.add(new JLabel(label),g);g.gridx=1;g.fill=GridBagConstraints.HORIZONTAL;g.weightx=1;p.add(c,g);}
}

class LoginPanel extends JPanel {
    LoginPanel(SafeHerFrame frame){setLayout(new BorderLayout());JLabel title=new JLabel("SafeHer",SwingConstants.CENTER);title.setFont(title.getFont().deriveFont(Font.BOLD,30f));add(title,BorderLayout.NORTH);
        JPanel p=SafeHerFrame.form();JTextField email=new JTextField(25);JPasswordField pass=new JPasswordField(25);SafeHerFrame.row(p,0,"Email",email);SafeHerFrame.row(p,1,"Password",pass);
        JButton login=new JButton("Sign in"),register=new JButton("Create account");JPanel actions=new JPanel();actions.add(login);actions.add(register);SafeHerFrame.row(p,2,"",actions);add(p,BorderLayout.CENTER);
        JLabel note=new JLabel("Prototype only: SOS records an alert locally; it does not contact emergency services.",SwingConstants.CENTER);add(note,BorderLayout.SOUTH);
        login.addActionListener(e->frame.login(email.getText(),pass.getPassword()));register.addActionListener(e->register(frame));
    }
    private void register(SafeHerFrame frame){JTextField name=new JTextField(22),email=new JTextField(22),phone=new JTextField(22);JPasswordField password=new JPasswordField(22);JPanel p=SafeHerFrame.form();SafeHerFrame.row(p,0,"Full name",name);SafeHerFrame.row(p,1,"Email",email);SafeHerFrame.row(p,2,"Phone",phone);SafeHerFrame.row(p,3,"Password (8+ chars)",password);int result=JOptionPane.showConfirmDialog(frame,p,"Create SafeHer account",JOptionPane.OK_CANCEL_OPTION,JOptionPane.PLAIN_MESSAGE);if(result==JOptionPane.OK_OPTION)frame.register(name.getText(),email.getText(),phone.getText(),password.getPassword());}
}

class DashboardPanel extends JPanel {
    private final SafeHerFrame frame;private final User user;private final ContactService contacts=new ContactService();private final AlertService alerts=new AlertService();private final JLabel counts=new JLabel();private final DefaultListModel<EmergencyContact> contactModel=new DefaultListModel<>();private final DefaultListModel<EmergencyAlert> alertModel=new DefaultListModel<>();private final JList<EmergencyContact> contactList=new JList<>(contactModel);private final JList<EmergencyAlert> alertList=new JList<>(alertModel);
    DashboardPanel(SafeHerFrame frame,User user){this.frame=frame;this.user=user;setLayout(new BorderLayout(8,8));setBorder(new EmptyBorder(12,16,16,16));JPanel top=new JPanel(new BorderLayout());top.add(new JLabel("Welcome, "+user.fullName()),BorderLayout.WEST);JButton logout=new JButton("Sign out");logout.addActionListener(e->frame.showLogin());top.add(logout,BorderLayout.EAST);top.add(counts,BorderLayout.SOUTH);add(top,BorderLayout.NORTH);
        JTabbedPane tabs=new JTabbedPane();tabs.addTab("Emergency contacts",contactPanel());tabs.addTab("SOS and alert history",alertPanel());add(tabs,BorderLayout.CENTER);refresh();}
    private JPanel contactPanel(){JPanel p=new JPanel(new BorderLayout(6,6));p.add(new JScrollPane(contactList),BorderLayout.CENTER);JPanel buttons=new JPanel();JButton add=new JButton("Add"),edit=new JButton("Edit"),del=new JButton("Delete"),refresh=new JButton("Refresh");buttons.add(add);buttons.add(edit);buttons.add(del);buttons.add(refresh);p.add(buttons,BorderLayout.SOUTH);add.addActionListener(e->editContact(null));edit.addActionListener(e->{EmergencyContact c=contactList.getSelectedValue();if(c==null){JOptionPane.showMessageDialog(frame,"Select a contact first.");return;}editContact(c);});del.addActionListener(e->{EmergencyContact c=contactList.getSelectedValue();if(c!=null&&JOptionPane.showConfirmDialog(frame,"Delete "+c.name()+"?","Confirm",JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION)run(()->contacts.delete(user.id(),c.id()));});refresh.addActionListener(e->refresh());return p;}
    private void editContact(EmergencyContact old){JTextField name=new JTextField(old==null?"":old.name(),20),phone=new JTextField(old==null?"":old.phone(),20),relation=new JTextField(old==null?"":old.relationship(),20);JPanel p=SafeHerFrame.form();SafeHerFrame.row(p,0,"Name",name);SafeHerFrame.row(p,1,"Phone",phone);SafeHerFrame.row(p,2,"Relationship",relation);int result=JOptionPane.showConfirmDialog(frame,p,old==null?"Add contact":"Edit contact",JOptionPane.OK_CANCEL_OPTION);if(result==JOptionPane.OK_OPTION)run(()->contacts.save(user.id(),old==null?0:old.id(),name.getText(),phone.getText(),relation.getText()));}
    private JPanel alertPanel(){JPanel p=new JPanel(new BorderLayout(6,6));JPanel sos=new JPanel(new GridLayout(0,2,6,6));JTextField lat=new JTextField(),lon=new JTextField(),note=new JTextField();JButton create=new JButton("Record test SOS alert");sos.add(new JLabel("Latitude (optional)"));sos.add(lat);sos.add(new JLabel("Longitude (optional)"));sos.add(lon);sos.add(new JLabel("Location note (optional)"));sos.add(note);sos.add(create);sos.add(new JLabel("Records locally only; no notification is sent."));p.add(sos,BorderLayout.NORTH);p.add(new JScrollPane(alertList),BorderLayout.CENTER);JPanel bottom=new JPanel();JComboBox<String> status=new JComboBox<>(new String[]{"CREATED","RESOLVED","CANCELLED"});JButton update=new JButton("Update selected status"),reload=new JButton("Refresh");bottom.add(status);bottom.add(update);bottom.add(reload);p.add(bottom,BorderLayout.SOUTH);create.addActionListener(e->{if(JOptionPane.showConfirmDialog(frame,"Create a local test alert record? No message will be sent.","Confirm test SOS",JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION)run(()->alerts.create(user.id(),lat.getText(),lon.getText(),note.getText()));});update.addActionListener(e->{EmergencyAlert a=alertList.getSelectedValue();if(a==null){JOptionPane.showMessageDialog(frame,"Select an alert first.");return;}run(()->alerts.updateStatus(user.id(),a.id(),(String)status.getSelectedItem()));});reload.addActionListener(e->refresh());return p;}
    private void run(SqlAction action){try{action.run();refresh();}catch(Exception e){SafeHerFrame.error(e);}}
    private void refresh(){try{contactModel.clear();for(EmergencyContact c:contacts.list(user.id()))contactModel.addElement(c);alertModel.clear();List<EmergencyAlert> list=alerts.list(user.id());for(EmergencyAlert a:list)alertModel.addElement(a);counts.setText("Contacts: "+contacts.count(user.id())+"    Alerts: "+alerts.count(user.id()));}catch(Exception e){SafeHerFrame.error(e);}}
    @FunctionalInterface private interface SqlAction{void run()throws Exception;}
}
