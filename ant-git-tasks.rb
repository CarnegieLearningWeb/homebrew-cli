class AntGitTasks < Formula
  desc "Git tasks for Apache Ant"
  homepage "https://github.com/rimerosolutions/ant-git-tasks"
  url "https://oss.sonatype.org/content/repositories/releases/com/rimerosolutions/ant/ant-git-tasks/1.3.2/ant-git-tasks-1.3.2.jar"
  sha256 "c1b304bd8fe0c39668a0c5b7450a516da87a25b8c13f8cb280820534522820db"

  bottle :unneeded

  depends_on "ant"

  resource "jsch" do
    url "https://search.maven.org/remotecontent?filepath=com/jcraft/jsch/0.1.54/jsch-0.1.54.jar"
    sha256 "92eb273a3316762478fdd4fe03a0ce1842c56f496c9c12fe1235db80450e1fdb"
  end

  resource "jgit" do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jgit/org.eclipse.jgit/3.0.0.201306101825-r/org.eclipse.jgit-3.0.0.201306101825-r.jar"
    sha256 "53c5fc56e5abbd6ee1a4f53a5fb811d309bbb3e6f877232d14dd2b126400f014"
  end

  resource "jgit-ant" do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jgit/org.eclipse.jgit.ant/3.0.0.201306101825-r/org.eclipse.jgit.ant-3.0.0.201306101825-r.jar"
    sha256 "90763c449ffac1590c31f9f922f7864faa5b903789c4347e08ddfce83e270fcd"
  end

  def install
    (share+"ant").install "ant-git-tasks-1.3.2.jar"

    resource("jsch").stage do
      (share+"ant").install Dir["*.jar"]
    end

    resource("jgit").stage do
      (share+"ant").install Dir["*.jar"]
    end

    resource("jgit-ant").stage do
      (share+"ant").install Dir["*.jar"]
    end
  end

  test do
    (testpath/"build.xml").write <<-EOS.undent
      <project name="HomebrewTest" default="init" basedir="."
          xmlns:git="antlib:com.rimerosolutions.ant.git">
        <taskdef uri="antlib:com.rimerosolutions.ant.git"
                 resource="com/rimerosolutions/ant/git/jgit-ant-lib.xml" />
        <target name="init">
          <git:settings refId="git.testing"
                        username="xxxtesting"
                        password="xxxtesting"
                        name="xxxtesting"
                        email="xxxtesting@example.com"/>

          <git:git directory="${testpath}/git" settingsRef="git.testing">
            <git:init bare="true" directory="#{testpath}/git"/>
          </git:git>
        </target>
      </project>
    EOS
    system Formula["ant"].opt_bin/"ant"
  end
end
