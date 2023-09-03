import jenkins.model.*
import hudson.util.Secret
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import org.jenkinsci.plugins.plaincredentials.StringCredentials
import org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl
import io.jenkins.plugins.gitlabserverconfig.credentials.PersonalAccessTokenImpl
import com.microsoft.azure.util.AzureCredentials

// Get the Jenkins instance
def jenkins = Jenkins.instance

// Access the credentials store
def credentials = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
    com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
    jenkins
)

// set Credentials domain name (null means is it global)
domainName = null

credentialsStore = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]?.getStore()
domain = new Domain(domainName, null, Collections.<DomainSpecification>emptyList())

// Iterate through credentials and decrypt them

credentialsStore?.getCredentials(domain).each{c ->
  if(c instanceof BasicSSHUserPrivateKey) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nKEY:\n%s\n", c.id, c.description, c.getPrivateKey()))
  }

  if(c instanceof UsernamePasswordCredentialsImpl) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nUSER: %s\nPASSWORD: %s\n", c.id, c.description, c.username, c.password))
  }

  if(c instanceof StringCredentials) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nSECRET: %s\n", c.id, c.description, c.secret))
  }

  if(c instanceof FileCredentialsImpl) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nCONTENT: %s\n", c.id, c.description, c.content))
  }
  
  if(c instanceof PersonalAccessTokenImpl) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nTOKEN: %s\n", c.id, c.description, c.token))
  }
  
  if(c instanceof AzureCredentials) {
    println(String.format("ID: %s\nDESCRIPTION: %s\nCLIENT_SECRET: %s\n", c.id, c.description, c.getPlainClientSecret()))
  }
}